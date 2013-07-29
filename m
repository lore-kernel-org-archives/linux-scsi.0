From: David Miller <davem@davemloft.net>
Subject: Re: sparc ESP SCSI error handling BUG+hang
Date: Mon, 29 Jul 2013 15:32:23 -0700 (PDT)
Message-ID: <20130729.153223.2291945302397524459.davem@davemloft.net>
References: <alpine.SOC.1.00.1304211357540.2145@math.ut.ee>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:54206 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239Ab3G2WcZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jul 2013 18:32:25 -0400
In-Reply-To: <alpine.SOC.1.00.1304211357540.2145@math.ut.ee>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mroos@linux.ee
Cc: sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org

From: Meelis Roos <mroos@linux.ee>
Date: Sun, 21 Apr 2013 14:02:11 +0300 (EEST)

> I revived my Sun E3000 after its main disk died, reinstalled Debian and 
> after long apuse I am testing linux kernels again on it. In general it 
> works fine but I left the bad disk connected and sometimes it causes ESP 
> SCSI BUG in esp_free_lun_tag. Sometimes it just works.

I think I know what is happening and am working on a fix.

If we issue an autosense command, we do so by hijacking the original
command that caused the check-condition.

When we do so we clear out the ent->tag[] array when we issue it via
find_and_prep_issuable_command().  This is so that the autosense
command is forced to be issued non-tagged.

That is problematic, because it is the value of ent->tag[] which
determines whether we issued the original scsi command as tagged
vs. non-tagged (see esp_alloc_lun_tag()).

And that, in turn, is what trips up the sanity checks in
esp_free_lun_tag().  That function needs the original ->tag[] values
in order to free up the tag slot properly.

Therefore I think the fix is going to involve adding a member to
"struct esp_cmd_entry" called "->orig_tag[]" so that we can see what
the original tag[] values were at esp_alloc_lun_tag() time.

Thanks for your patience.
