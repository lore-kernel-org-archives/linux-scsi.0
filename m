Return-Path: <SRS0=2Pbo=54=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F56DC2D0EC
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Apr 2020 04:57:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 248A520709
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Apr 2020 04:57:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725832AbgDLE5u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Apr 2020 00:57:50 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:39487 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725812AbgDLE5u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Apr 2020 00:57:50 -0400
Received: by mail-pl1-f194.google.com with SMTP id k18so2210791pll.6
        for <linux-scsi@vger.kernel.org>; Sat, 11 Apr 2020 21:57:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=8kubA89XCTfqZN3MKeEKs33DADLOnZsGllbO5q/tZLI=;
        b=Xc6GRQRQpF4Twj3FSij5zIlG9HVxRLMF17LkQK2R77FMdQqHViVdM8aDpTgXxFtZ56
         NSSyTEkPHkPObm4BQwIkjAXp96yibv9P8v8ziqBAonEIJkHGr5O5EqmU7j7/wtXYIAu/
         khrPSWweGlnqFQKhvL7HRXQm3ZyjjNrvkzl6WRi7tZa3to9lt2Cka+1waETvjEZWJC77
         nMct7pGUgLN/l2VS98AqsTKRK6ifph6issUxmPGnd/2F88MpYyz9V84HDGPQMQQT6j/v
         TL+8WY7KjFipVuzS2lTIzrJaE2HHn534WXH5ZrbjnCSuVWS3TB3jpoQmA02ow6JnrVxX
         JHwg==
X-Gm-Message-State: AGi0PuYgICdHQ3SsSS5l3cD+gnfDEkVNiAoRx7X77itzxHE6Nxbv+WHh
        g0omAYhhWNVtAVKgy5Ph/M8=
X-Google-Smtp-Source: APiQypLpI63wcun08ofogok1dMN03w0O/nKT/u3sgLTOekc+/XDdlCsy5vKNBSh9otF9VmVqv0ho4g==
X-Received: by 2002:a17:90a:640d:: with SMTP id g13mr14085777pjj.67.1586667467701;
        Sat, 11 Apr 2020 21:57:47 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:c9fa:49a8:1701:9c75? ([2601:647:4000:d7:c9fa:49a8:1701:9c75])
        by smtp.gmail.com with ESMTPSA id p1sm5616717pjr.40.2020.04.11.21.57.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Apr 2020 21:57:46 -0700 (PDT)
Subject: Re: [PATCH v3 24/31] elx: efct: LIO backend interface routines
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     dwagner@suse.de, maier@linux.ibm.com, herbszt@gmx.de,
        natechancellor@gmail.com, rdunlap@infradead.org, hare@suse.de,
        Ram Vegesna <ram.vegesna@broadcom.com>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
 <20200412033303.29574-25-jsmart2021@gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
Autocrypt: addr=bvanassche@acm.org; prefer-encrypt=mutual; keydata=
 mQENBFSOu4oBCADcRWxVUvkkvRmmwTwIjIJvZOu6wNm+dz5AF4z0FHW2KNZL3oheO3P8UZWr
 LQOrCfRcK8e/sIs2Y2D3Lg/SL7qqbMehGEYcJptu6mKkywBfoYbtBkVoJ/jQsi2H0vBiiCOy
 fmxMHIPcYxaJdXxrOG2UO4B60Y/BzE6OrPDT44w4cZA9DH5xialliWU447Bts8TJNa3lZKS1
 AvW1ZklbvJfAJJAwzDih35LxU2fcWbmhPa7EO2DCv/LM1B10GBB/oQB5kvlq4aA2PSIWkqz4
 3SI5kCPSsygD6wKnbRsvNn2mIACva6VHdm62A7xel5dJRfpQjXj2snd1F/YNoNc66UUTABEB
 AAG0JEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPokBOQQTAQIAIwUCVI67
 igIbAwcLCQgHAwIBBhUIAgkKCwQWAgMBAh4BAheAAAoJEHFcPTXFzhAJ8QkH/1AdXblKL65M
 Y1Zk1bYKnkAb4a98LxCPm/pJBilvci6boefwlBDZ2NZuuYWYgyrehMB5H+q+Kq4P0IBbTqTa
 jTPAANn62A6jwJ0FnCn6YaM9TZQjM1F7LoDX3v+oAkaoXuq0dQ4hnxQNu792bi6QyVdZUvKc
 macVFVgfK9n04mL7RzjO3f+X4midKt/s+G+IPr4DGlrq+WH27eDbpUR3aYRk8EgbgGKvQFdD
 CEBFJi+5ZKOArmJVBSk21RHDpqyz6Vit3rjep7c1SN8s7NhVi9cjkKmMDM7KYhXkWc10lKx2
 RTkFI30rkDm4U+JpdAd2+tP3tjGf9AyGGinpzE2XY1K5AQ0EVI67igEIAKiSyd0nECrgz+H5
 PcFDGYQpGDMTl8MOPCKw/F3diXPuj2eql4xSbAdbUCJzk2ETif5s3twT2ER8cUTEVOaCEUY3
 eOiaFgQ+nGLx4BXqqGewikPJCe+UBjFnH1m2/IFn4T9jPZkV8xlkKmDUqMK5EV9n3eQLkn5g
 lco+FepTtmbkSCCjd91EfThVbNYpVQ5ZjdBCXN66CKyJDMJ85HVr5rmXG/nqriTh6cv1l1Js
 T7AFvvPjUPknS6d+BETMhTkbGzoyS+sywEsQAgA+BMCxBH4LvUmHYhpS+W6CiZ3ZMxjO8Hgc
 ++w1mLeRUvda3i4/U8wDT3SWuHcB3DWlcppECLkAEQEAAYkBHwQYAQIACQUCVI67igIbDAAK
 CRBxXD01xc4QCZ4dB/0QrnEasxjM0PGeXK5hcZMT9Eo998alUfn5XU0RQDYdwp6/kMEXMdmT
 oH0F0xB3SQ8WVSXA9rrc4EBvZruWQ+5/zjVrhhfUAx12CzL4oQ9Ro2k45daYaonKTANYG22y
 //x8dLe2Fv1By4SKGhmzwH87uXxbTJAUxiWIi1np0z3/RDnoVyfmfbbL1DY7zf2hYXLLzsJR
 mSsED/1nlJ9Oq5fALdNEPgDyPUerqHxcmIub+pF0AzJoYHK5punqpqfGmqPbjxrJLPJfHVKy
 goMj5DlBMoYqEgpbwdUYkH6QdizJJCur4icy8GUNbisFYABeoJ91pnD4IGei3MTdvINSZI5e
Message-ID: <dc132a7c-0d82-7439-dad0-c35a6acab1f7@acm.org>
Date:   Sat, 11 Apr 2020 21:57:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200412033303.29574-25-jsmart2021@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-04-11 20:32, James Smart wrote:
> +	return EFC_SUCCESS;
> +}

Redefining 0 is unusual in the Linux kernel. I prefer to see "return 0;"
instead of "return ${DRIVER_NAME}_SUCCESS;".

> +static int  efct_lio_tgt_session_data(struct efct *efct, u64 wwpn,
> +				      char *buf, int size)
> +{
> +	struct efc_sli_port *sport = NULL;
> +	struct efc_node *node = NULL;
> +	struct efc *efc = efct->efcport;
> +	u16 loop_id = 0;
> +	int off = 0, rc = 0;
> +
> +	if (!efc->domain) {
> +		efc_log_err(efct, "failed to find efct/domain\n");
> +		return EFC_FAIL;
> +	}
> +
> +	list_for_each_entry(sport, &efc->domain->sport_list, list_entry) {
> +		if (sport->wwpn != wwpn)
> +			continue;
> +		list_for_each_entry(node, &sport->node_list,
> +				    list_entry) {
> +			/* Dump only remote NPORT sessions */
> +			if (!efct_lio_node_is_initiator(node))
> +				continue;
> +
> +			rc = snprintf(buf + off, size - off,
> +				"0x%016llx,0x%08x,0x%04x\n",
> +				get_unaligned_be64(node->wwpn),
> +				node->rnode.fc_id, loop_id);
> +			if (rc < 0)
> +				break;
> +			off += rc;
> +		}
> +	}
> +
> +	return EFC_SUCCESS;
> +}

This is one of the most unfriendly debugfs data formats I have seen so
far: information about all sessions is dumped into one huge debugfs
attribute.

Is information about active sessions useful for other LIO target
drivers? Wasn't it promised that this functionality would be moved into
the LIO core instead of defining it for the efct driver only?

> +static int efct_debugfs_session_open(struct inode *inode, struct file *filp)
> +{
> +	struct efct_lio_sport *sport = inode->i_private;
> +	int size = 17 * PAGE_SIZE; /* 34 byte per session*2048 sessions */
> +
> +	if (!(filp->f_mode & FMODE_READ)) {
> +		filp->private_data = sport;
> +		return EFC_SUCCESS;
> +	}
> +
> +	filp->private_data = kmalloc(size, GFP_KERNEL);
> +	if (!filp->private_data)
> +		return -ENOMEM;
> +
> +	memset(filp->private_data, 0, size);
> +	efct_lio_tgt_session_data(sport->efct, sport->wwpn, filp->private_data,
> +				  size);
> +	return EFC_SUCCESS;
> +}

kmalloc() + memset() can be changed into kzalloc().

The above code allocates 68 KB physically contiguous memory? Kernel code
should not rely on higher order page allocations unless there is no
other choice.

Additionally, I see that the amount of memory allocated is independent
of the number of sessions. I think there are better approaches.

> +
> +	lio_wq = create_singlethread_workqueue("efct_lio_worker");
> +	if (!lio_wq) {
> +		efc_log_err(efct, "workqueue create failed\n");
> +		return -ENOMEM;
> +	}

Is any work queued onto lio_wq that needs to be serialized against other
work queued onto the same queue? If not, can one of the system
workqueues be used, e.g. system_wq?

Thanks,

Bart.
