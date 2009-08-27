From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 5/5] scsi_debug: Implement support for DIF Type 2
Date: Thu, 27 Aug 2009 09:41:18 -0400
Message-ID: <1251380478.6426.11.camel@mulgrave.site>
References: <1251267481-24135-1-git-send-email-martin.petersen@oracle.com>
	 <1251267481-24135-6-git-send-email-martin.petersen@oracle.com>
	 <4A952D54.5010102@panasas.com> <yq1ab1l91zy.fsf@sermon.lab.mkp.net>
	 <4A965366.7080409@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45066 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747AbZH0Nl0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Aug 2009 09:41:26 -0400
In-Reply-To: <4A965366.7080409@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

On Thu, 2009-08-27 at 12:35 +0300, Boaz Harrosh wrote:
> On 08/27/2009 09:58 AM, Martin K. Petersen wrote:
> >>>>>> "Boaz" == Boaz Harrosh <bharrosh@panasas.com> writes:
> > 
> >>> + *lba = (u64)cmd[19] | (u64)cmd[18] << 8 |
> >>> + (u64)cmd[17] << 16 | (u64)cmd[16] << 24 |
> >>> + (u64)cmd[15] << 32 | (u64)cmd[14] << 40 |
> >>> + (u64)cmd[13] << 48 | (u64)cmd[12] << 56;
> > 
> > Boaz> get_unaligned_be64()
> > 
> > As you noticed further down in that patch I do generally use the
> > get_unaligned_* macros in "my own" code.
> > 
> > However, when I update somebody else's code I try to match the existing
> > style.  And in this case rest of get_data_transfer_info() is using
> > explicit shifts and to me it looks absolutely horrendous to mix the two.
> > 
> > I generally avoid mixing cleanups and new functionality.  I don't have a
> > problem with switching over to the macros, but in that case I think the
> > whole function should be updated.  And that should be an orthogonal
> > patch.
> > 
> 
> I don't know. For me it is like checkpatch. I do not submit code over 80
> chars even if surrounding code does. "The new code rule".

I'd take that as a guideline rather than a rule ... Especially when
lindent will generate 80 column long function templates over tens of
lines squashing about five letters per line ...

> I generally agree with what you say but I think there is a balance.
> Personally, I think this is over the balance point, but it's your call.

The general rule is not to confuse coding styles, so the correct way to
add stuff is to use the existing conventions in the file.  You can
optionally convert the entire style if necessary.  However, for these
get_cpu_be macros, there's no real benefit other than saving typing, so
a global conversion effort simply isn't worth it.

James


