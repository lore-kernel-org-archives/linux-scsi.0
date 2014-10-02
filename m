From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: ufs: Add freq-table-hz property for UFS device
Date: Thu, 2 Oct 2014 18:23:15 +0300
Message-ID: <20141002152315.GA27277@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20247 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754422AbaJBPXa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2014 11:23:30 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stummala@codeaurora.org
Cc: linux-scsi@vger.kernel.org

Hello Sahitya Tummala,

The patch 4cff6d991e4a: "ufs: Add freq-table-hz property for UFS
device" from Sep 25, 2014, leads to the following static checker
warning:

	drivers/scsi/ufs/ufshcd-pltfrm.c:138 ufshcd_parse_clock_info()
	warn: passing devm_ allocated variable to kfree. 'clkfreq'

drivers/scsi/ufs/ufshcd-pltfrm.c
   102          clkfreq = devm_kzalloc(dev, sz * sizeof(*clkfreq),
   103                          GFP_KERNEL);
                          ^^^^^^^^^^^^^
   104          if (!clkfreq) {
   105                  dev_err(dev, "%s: no memory\n", "freq-table-hz");

Don't print an error.  It just wastes ram.  Error messages are often
buggy.  If we delete it then the code is shorter and easier to read.
Kmalloc() has its own more useful error message already.

   106                  ret = -ENOMEM;
   107                  goto out;

Out labels are the worst.  The name is too vague.  They are a sign of
either One Err type error handling where you have one label handle
everything or they are a just a do-nothing goto where it returns
directly.

One Err type error handling causes bugs.

Do-nothing gotos are just annoying.  You're reading the code and you see
a "goto out;" and you think "What does "out" do?"  But the name doesn't
provide any hints.  You scroll down to the bottom of the function.  "Oh
it was just a waste of time."  Now you have lost your place and your
train of thought.

Also people constantly forget to set "ret" before the goto out.  If you
just write:


	if (!of_get_property(np, "freq-table-hz", &len)) {
		dev_info(dev, "freq-table-hz property not specified\n");
		return 0;
	}

	if (len <= 0)
		return 0;

Then it's totally clear what we intended to return.  But in the current
code it's ambiguous because maybe we just forgot to set ret?  Who
knows.  Out labels make the code hard to understand.

Anyway, in this case, originally "out" was doing One Err error handling
but now it's just there to waste our time and cause bugs when this code
is modified in the future.

   108          }
   109  
   110          ret = of_property_read_u32_array(np, "freq-table-hz",
   111                          clkfreq, sz);
   112          if (ret && (ret != -EINVAL)) {
   113                  dev_err(dev, "%s: error reading array %d\n",
   114                                  "freq-table-hz", ret);
   115                  goto free_clkfreq;
   116          }
   117  
   118          for (i = 0; i < sz; i += 2) {
   119                  ret = of_property_read_string_index(np,
   120                                  "clock-names", i/2, (const char **)&name);
   121                  if (ret)
   122                          goto free_clkfreq;
   123  
   124                  clki = devm_kzalloc(dev, sizeof(*clki), GFP_KERNEL);
   125                  if (!clki) {
   126                          ret = -ENOMEM;
   127                          goto free_clkfreq;
   128                  }
   129  
   130                  clki->min_freq = clkfreq[i];
   131                  clki->max_freq = clkfreq[i+1];
   132                  clki->name = kstrdup(name, GFP_KERNEL);

Where is name freed?  There are definitely certain error paths where it
is leaked.  Can we use devm_kstrdup() here?

   133                  dev_dbg(dev, "%s: min %u max %u name %s\n", "freq-table-hz",
   134                                  clki->min_freq, clki->max_freq, clki->name);
   135                  list_add_tail(&clki->list, &hba->clk_list_head);
   136          }
   137  free_clkfreq:
   138          kfree(clkfreq);
                ^^^^^^^^^^^^^
Just delete this.

   139  out:
   140          return ret;
   141  }

regards,
dan carpenter
