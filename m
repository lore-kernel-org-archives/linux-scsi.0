From: Suresh Babu Kandukuru <suresh.babu.kandukuru@oracle.com>
Subject: RE: [Scst-devel] scst qla2xxx.ko  VS kernel qla2xxx.ko
Date: Fri, 20 Mar 2015 22:59:30 -0700 (PDT)
Message-ID: <13fade5e-79b7-492e-ac16-28e2f8e2b8b7@default>
References: <Suresh> <Babu> <Kandukuru> <<suresh.babu.kandukuru@oracle.com>>
 <"Re:> <[Scst-devel]> <scst> <qla2xxx.ko> <VS> <kernel> <qla2xxx.ko"> <(Mar>
 <13,> <4:18am)> <<201503202005.t2KK5qSs019140@wind.enjellic.com>>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25797 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbbCUF7w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Mar 2015 01:59:52 -0400
In-Reply-To: <<201503202005.t2KK5qSs019140@wind.enjellic.com>>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: greg@enjellic.com, Suresh Babu Kandukuru <suresh.babu.kandukuru@oracle.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>, scst-devel@lists.sourceforge.net
Cc: linux-scsi@vger.kernel.org

Greg . Thank you very much for the detailed mail . I will mail you and the list for any further quires to the list . Thanks.

/Suresh 

-----Original Message-----
From: Dr. Greg Wettstein [mailto:greg@wind.enjellic.com] 
Sent: Saturday, March 21, 2015 1:36 AM
To: Suresh Babu Kandukuru; Bart Van Assche; scst-devel@lists.sourceforge.net
Cc: linux-scsi@vger.kernel.org
Subject: Re: [Scst-devel] scst qla2xxx.ko VS kernel qla2xxx.ko

On Mar 13,  4:18am, Suresh Babu Kandukuru wrote:
} Subject: Re: [Scst-devel] scst qla2xxx.ko  VS kernel qla2xxx.ko

Hi, I hope the week is closing out well for everyone.

> Thanks Bart . We have tested with 2.2.0 and 3.0.1 
> (scst-svn-6135-branches-3.0.x ) ., loaded all the scst ko files along 
> with qla2xxx_scst.ko qla2x00t.ko . Still this did not any FC ports in 
> /sys/class/fc_hosts/.. .  The QLOGIC HBA we are using is "QLogic 
> QLE8362 - 7101674, Sun Storage 16Gb FC PCIe Universal HBA, QLogic. " . 
> Does the scst qla2xxx_scst.ko driver supports this ?. what we are 
> missing here ?. Any pointers are helpful . Thanks

We have had the opportunity to architect, build, maintain and debug complex converged data and storage networks.  The switches on these networks are a million dollars apiece and there are multiple switches in multiple data-centers.

The storage, running at about one-half petabyte levels, is all SCST based and we use Qlogic HBA's and CNA's on both the initiators and targets.  Given the somewhat colorful history with respect to Qlogic target driver support we had to roll up our sleeves and write an interface driver which allows SCST to run on top of the Qlogic target driver in stock Linux kernels.

I just put an integrated patchset which includes SCST 3.0.0, our target interface driver and a few patches to the in-kernel target driver we carry to make all of this work correctly and address various regressions in the stock target driver.  You can grab the patchset from the following URL:

ftp://ftp.enjellic.com/pub/scst/sqa-1.2_scst-3.0.0_3.10.67.patch.gz

All of the storage targets are direct FCOE attachments using Qlogic
8362 CNA's.  The above patchset is what we are currently using in production and it has been validated over hundreds and hundreds of terrabytes of I/O, which includes exposure to some rather rigorous fabric and TMF event processing situations.  We have also tracked down some rather elusive switch based FCOE transport issues with this codebase.

Obviously your mileage may vary.

If you drop the above patch onto a 3.10 kernel source tree and build a kernel with the appropriate configuration options it should work with whatever cards are supported by the stock Linux kernel.  One of the patches which is included sets the card to QLA2XXX_INI_MODE_EXCLUSIVE which causes the card to come up 'target capable' by default which mirrors the behavior of the SCST supplied Qlogic target driver.

In your note you indicate your card is a 'QLogic QLE8362 - 7101674, Sun Storage 16Gb FC PCIe Universal HBA' which I assume is probably an OEM rebranded card.  The 8362 is actually a Converged Network Adapter
(CNA) rather then an HBA.  The 2672 is the 'fibre-channel' HBA version of the card.  The stock Qlogic cards are dual-personality cards which allows their operational mode, ie 16 GBPS FC or 10 GBPS ethernet, to be selected through the BIOS setup utilities.

Given your e-mail address, I'm sure you've jumped through all these hoops but one obviously wants to have the card setup with the right personality and correct optics for your physical transport layer.

You also probably want to make sure you have both your HBA/CNA and motherboard up to the most recent versions of their respective firmware.  There are issues particularly with Intel S2600 motherboards and these cards which requires updated firmware on both sides.

If the card is detected and found to be target capable by the stock Linux kernel Qlogic driver you will find the available target PWWN's in the following directory:

/sys/kernel/scst_tgt/targets/sqatgt

If there are none present there is the possibility that the card has been modified in firmware to prohibit target mode or has a modified PCI id which is causing problems for the driver probe logic.  If that is the case the card isn't going to be a candidate for use in target mode.  We tend to recommend that people buy straight Qlogic branded cards to avoid these sorts of issues.

Just as an FYI/CYA there are session management issues/bugs in the Qlogic target driver, regardless of breed; SCST, Qlogic SCST or kernel.  These can show up during asynchronous fabric processing events, particularly if you are aggressive in placing the card and fabric under duress.

We are in the process of upgrading our patchset to 3.0.1 which will include a number of additional fixes to the in-kernel Qlogic target driver.  I will shoot a note off to the list when it is available if you or others find this stuff useful.

I hope the above is helpful.

Good luck with your project.

Greg

}-- End of excerpt from Suresh Babu Kandukuru

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"If you plugged up your nose and mouth right before you sneezed, would  the sneeze go out your ears or would your head explode?  Either way I'm  afraid to try."
                                -- Nick Kean
