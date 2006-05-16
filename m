From: "Ju, Seokmann" <Seokmann.Ju@lsil.com>
Subject: RE: [RFC] Megaraid update, submission
Date: Tue, 16 May 2006 13:03:24 -0600
Message-ID: <890BF3111FB9484E9526987D912B261901BD80@NAMAIL3.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:41940 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751932AbWEPTDt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 May 2006 15:03:49 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andre Hedrick <andre@linux-ide.org>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@osdl.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@infradead.org>, "Mukker, Atul" <Atul.Mukker@engenio.com>

Hi,

I cannot agree on the changes in the patch for following reasons.

On Tuesday, May 16, 2006 1:44 PM, Andre Hedrick wrote:
> Random (hard to reproduce, without a noise injection into the SATA
> connector or cable) hardware error states which locks the 
> card and in the
> majority of the cases caused the array to be lost.  If the 
> array was not
> lost then a drive was failed but one could not remove/replace w/ a new
> drive.  Thus adding in a pci_master_abort test and clear 
> function proved
> to allow recovery in all cases where the card shutdown 
> communication to
> the host.  This may not address all cases; however, clearly this is a
> missing part of the driver base when entry to eh_scsi_* begins.
If 'raid_dev->hw_error' is non-zero, this means that the controller has gone bad and will (and should not to avoid further memory corruption) not be able to recoverd unless reboot.
The overall issue described here already taken care by the patch that I've submitted.
The patch has been accepted and should be available on 2.6.17-rc1-mm3 as specified in Andrew Morton's email.
> The compond issue in the failed recovery resulted in a deref 
> NULL pointer
> in the various list_head calls.  After change the individual 
> list_add to
> list_move and such, the NULL point issue has never shown up 
> in the past 6
> weeks of heavy testing.
I'm not sure how this changes help for the issue. Furthermore, I'm not sure what is _the NULL point issue_ refering to. If you see the issue with driver available on 2.6.17-rc1-mm3, please let me know.
Following link will leads you to further details of the patch.
http://www.kernel.org/git/?p=linux/kernel/git/jejb/scsi-rc-fixes-2.6.git;a=commit;h=c005fb4fb2d23ba29ad21dee5042b2f8451ca8ba

Thank you,

Seokmann

> -----Original Message-----
> From: Andre Hedrick [mailto:andre@linux-ide.org] 
> Sent: Tuesday, May 16, 2006 1:44 PM
> To: linux-scsi@vger.kernel.org; Ju, Seokmann; Andrew Morton
> Cc: James Bottomley; Christoph Hellwig; Mukker, Atul
> Subject: [RFC] Megaraid update, submission
> 
> 
> Linux-scsi, et al.
> 
> The follow patch address two major issues found under 
> extensive testing.
> 
> While pounding data io down the card and performing large 
> scale queries to
> the controller about device state and function parameters, 
> the following
> were discovered.
> 
> Random (hard to reproduce, without a noise injection into the SATA
> connector or cable) hardware error states which locks the 
> card and in the
> majority of the cases caused the array to be lost.  If the 
> array was not
> lost then a drive was failed but one could not remove/replace w/ a new
> drive.  Thus adding in a pci_master_abort test and clear 
> function proved
> to allow recovery in all cases where the card shutdown 
> communication to
> the host.  This may not address all cases; however, clearly this is a
> missing part of the driver base when entry to eh_scsi_* begins.
> 
> The compond issue in the failed recovery resulted in a deref 
> NULL pointer
> in the various list_head calls.  After change the individual 
> list_add to
> list_move and such, the NULL point issue has never shown up 
> in the past 6
> weeks of heavy testing.
> 
> In all cases in the past, the baseline for error was 6:1.  
> Meaning either
> one system in six failed and/or one in six test/stress runs 
> failed.  With
> the attached changes, there have been zero failures in the past three
> weeks.  This sound great, but I wish it would fail to allow some
> statistics of improved error handling.
> 
> Please note the changes to SAS are minor and not tested, but 
> seem correct
> for the entire directory code base.  SAS shares the CMM core 
> with MBOX,
> thus the rational for changes to SAS.
> 
> Please comment and provide suggestions.
> 
> Cheers,
> 
> Andre Hedrick
> LAD Storage Consulting Group
> 
> 
> 
> 
