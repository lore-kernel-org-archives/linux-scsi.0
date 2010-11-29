From: scameron@beardog.cce.hp.com
Subject: Re: Booting problems with hpsa  - 2.6.37-rc3-9
Date: Mon, 29 Nov 2010 13:50:08 -0600
Message-ID: <20101129195008.GA7751@beardog.cce.hp.com>
References: <1FB7DC5E34DADB499463B6EA89DF40A46627944142@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0028.austin.hp.com ([15.216.28.35]:47448 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab0K2TuK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Nov 2010 14:50:10 -0500
Content-Disposition: inline
In-Reply-To: <1FB7DC5E34DADB499463B6EA89DF40A46627944142@MNEXMB1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Saurav Kashyap <saurav.kashyap@qlogic.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Madhu Iyengar <madhu.iyengar@qlogic.com>, Lalit Chandivade <lalit.chandivade@qlogic.com>

On Mon, Nov 29, 2010 at 04:58:38AM -0600, Saurav Kashyap wrote:
> Hi Stephen,
> While working on 2.6.37-rc3-9 I have noticed a bug  introduced by introduction of hpsa driver.
> The HP machine which uses hpsa driver never boots up because it's not able to find the /dev/cciss node.
> 
> I looked at the code and found that the cciss is registered as a block driver in pci probe(cciss_init_one) function. All the pci  (PCI_DEVICE_ID_HP_CISSE) devices has been moved to hpsa module. The cciss "cciss_init_one" function is never called for these device and node never gets created and the system fails to boot.
> 
> Thanks,
> ~Saurav Kashyap
> QLogic, India
> Tel: (91) (20) 3-025-5900 extension 5911
> Cell: (91) 992-380-0983
> 

Which Smart Array controller?

For newer kernels and newer controllers, we are transitioning
things to hpsa, and we do not want any overlap between the
two drivers.

For cciss, the supported controllers in newer kernels should be:

        {0x40700E11, "Smart Array 5300", &SA5_access},
        {0x40800E11, "Smart Array 5i", &SA5B_access},
        {0x40820E11, "Smart Array 532", &SA5B_access},
        {0x40830E11, "Smart Array 5312", &SA5B_access},
        {0x409A0E11, "Smart Array 641", &SA5_access},
        {0x409B0E11, "Smart Array 642", &SA5_access},
        {0x409C0E11, "Smart Array 6400", &SA5_access},
        {0x409D0E11, "Smart Array 6400 EM", &SA5_access},
        {0x40910E11, "Smart Array 6i", &SA5_access},
        {0x3225103C, "Smart Array P600", &SA5_access},
        {0x3223103C, "Smart Array P800", &SA5_access},
        {0x3234103C, "Smart Array P400", &SA5_access},
        {0x3235103C, "Smart Array P400i", &SA5_access},
        {0x3211103C, "Smart Array E200i", &SA5_access},
        {0x3212103C, "Smart Array E200", &SA5_access},
        {0x3213103C, "Smart Array E200i", &SA5_access},
        {0x3214103C, "Smart Array E200i", &SA5_access},
        {0x3215103C, "Smart Array E200i", &SA5_access},
        {0x3237103C, "Smart Array E500", &SA5_access},
        {0x323d103c, "Smart Array P700M", &SA5_access},

For hpsa, it should be:

        {0x3241103C, "Smart Array P212", &SA5_access},
        {0x3243103C, "Smart Array P410", &SA5_access},
        {0x3245103C, "Smart Array P410i", &SA5_access},
        {0x3247103C, "Smart Array P411", &SA5_access},
        {0x3249103C, "Smart Array P812", &SA5_access},
        {0x324a103C, "Smart Array P712m", &SA5_access},
        {0x324b103C, "Smart Array P711m", &SA5_access},
        {0x3233103C, "StorageWorks P1210m", &SA5_access},
        {0x333F103C, "StorageWorks P1210m", &SA5_access},
        {0x3350103C, "Smart Array", &SA5_access},
        {0x3351103C, "Smart Array", &SA5_access},
        {0x3352103C, "Smart Array", &SA5_access},
        {0x3353103C, "Smart Array", &SA5_access},
        {0x3354103C, "Smart Array", &SA5_access},
        {0x3355103C, "Smart Array", &SA5_access},

So, a few which used to be supported by cciss are now supported
only by hpsa, and there should be no overlap between the two
drivers.

If you've just *got* to have support for one of those controllers
in cciss that is now in hpsa, you can edit cciss.c, and add it back
into the cciss_pci_device_id[] and products[] array and recompile it.
(However, this will not be tested by HP with newer controllers, and 
might not even work right with newer controllers.)

I did notice in 2.6.37-rc3, some changes were made to cciss, but not
the corresponding changes to hpsa.  I think James Bottomley
has corresponding patches in his tree for hpsa.

Note, distro provided kernels (e.g. sles11 in particular) or HP provided
drivers for certain distros may have a slightly different set of controllers
in cciss or hpsa (for example sles 11 kind of scooped up hpsa and put it in
their distro before we were really expecting them to, which gave us some
interesting wrinkles to have to work through.)

I've noticed on RHEL6, udev seems to be smart enough that you
can kind of switch out cciss and hpsa and either way it will find the
boot device regardless of whether it shows up as /dev/cciss/c*d* or
/dev/sd*.  Also, the driver load order is not deterministic.  This means
that if there is any overlap between cciss and hpsa, then you never know
for sure which driver will grab the devices in the set that overlap.  It
might boot up anyway if you have a recent enough and nicely configured
udev, but it is disconcerting to say the least if on one boot, / is coming
from /dev/sda and on another, it randomly switches to /dev/cciss/c0d0.
Because of this, we do not want there to be any overlap between the drivers.
Also, kdump initrd images tend to contain a stripped down udev, and they
will behave a little differently than the regular udev, and this will lead
to problems if there is overlap in the devices supported by cciss
and hpsa (failed boot into kdump kernel, or failure to find the dump
device, for example.)

So, what you're seeing is not a bug.  It's a deliberate change.  However,
you might be missing the corresponding changes for hpsa if they're not yet
merged from James Bottomley's tree.

Hope that helps.

-- steve

