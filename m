From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: RE: Booting problems with hpsa  - 2.6.37-rc3-9
Date: Tue, 30 Nov 2010 00:49:44 -0600
Message-ID: <1FB7DC5E34DADB499463B6EA89DF40A466279441E2@MNEXMB1.qlogic.org>
References: <1FB7DC5E34DADB499463B6EA89DF40A46627944142@MNEXMB1.qlogic.org>
 <20101129195008.GA7751@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:16979 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484Ab0K3Gtv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Nov 2010 01:49:51 -0500
In-Reply-To: <20101129195008.GA7751@beardog.cce.hp.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "scameron@beardog.cce.hp.com" <scameron@beardog.cce.hp.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Madhu Iyengar <madhu.iyengar@qlogic.com>, Lalit Chandivade <lalit.chandivade@qlogic.com>

Stephen,

Following is the information about the Smart Array controller
-----------
linux-dcaw:~ # lspci | grep Hew
01:04.4 USB Controller: Hewlett-Packard Company Proliant iLO2 virtual USB controller
01:04.6 IPMI SMIC interface: Hewlett-Packard Company Proliant iLO2 virtual UART
05:00.0 RAID bus controller: Hewlett-Packard Company Smart Array G6 controllers (rev 01)
linux-dcaw:~ # lspci -n | grep 05.00.0
05:00.0 0104: 103c:323a (rev 01)

linux-dcaw:~ # cat /sys/class/pci_bus/0000\:05/device/subsystem/devices/0000\:05\:00.0/subsystem_device 
0x3245
linux-dcaw:~ # cat /sys/class/pci_bus/0000\:05/device/subsystem/devices/0000\:05\:00.0/subsystem_vendor 
0x103c

linux-dcaw:~ # cat /sys/class/pci_bus/0000\:05/device/subsystem_device 
0x330b
linux-dcaw:~ # cat /sys/class/pci_bus/0000\:05/device/subsystem_vendor 
0x103c
-------------

I tried changing the path from "/dev/cciss" to "/dev/disk/by-uuid/" but still having issues. The node "/dev/disk" is not getting created.

I tried the below patch also but without any success.

----------------
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index b2fb2b2..5c3adc2 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -115,11 +115,11 @@ static struct board_type products[] = {
        {0x324b103C, "Smart Array P711m", &SA5_access},
        {0x3233103C, "StorageWorks P1210m", &SA5_access},
        {0x333F103C, "StorageWorks P1210m", &SA5_access},
-       {0x3250103C, "Smart Array", &SA5_access},
-       {0x3250113C, "Smart Array", &SA5_access},
-       {0x3250123C, "Smart Array", &SA5_access},
-       {0x3250133C, "Smart Array", &SA5_access},
-       {0x3250143C, "Smart Array", &SA5_access},
+       {0x3350103C, "Smart Array", &SA5_access},
+       {0x3350113C, "Smart Array", &SA5_access},
+       {0x3350123C, "Smart Array", &SA5_access},
+       {0x3350133C, "Smart Array", &SA5_access},
+       {0x3350143C, "Smart Array", &SA5_access},
        {0xFFFF103C, "Unknown Smart Array", &SA5_access},
 };

--------------


On moving the changes back to cciss pci_device_id and use cciss, system boots fine (with both /dev/disk/by-uuid/ and with /dev/cciss/).
Here is the patch which I created (basically reverting back to cciss from hpsa)


diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c index a67d0a6..b640982 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -65,6 +65,14 @@ MODULE_SUPPORTED_DEVICE("HP Smart Array Controllers");  MODULE_VERSION("3.6.26");  MODULE_LICENSE("GPL");
 
+static int cciss_allow_hpsa = 0;
+module_param(cciss_allow_hpsa, int, S_IRUGO|S_IWUSR); 
+MODULE_PARM_DESC(cciss_allow_hpsa,
+	"Prevent cciss driver from accessing hardware known to be "
+	" supported by the hpsa driver");
+
+
+
 static DEFINE_MUTEX(cciss_mutex);
 
 #include "cciss_cmd.h"
@@ -93,6 +101,18 @@ static const struct pci_device_id cciss_pci_device_id[] = {
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSD,     0x103C, 0x3215},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSC,     0x103C, 0x3237},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSC,     0x103C, 0x323D},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3241},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3243},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3245},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3247},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3249},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x324A},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x324B},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3250},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3251},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3252},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3253},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3254},
 	{0,}
 };
 
@@ -106,6 +126,8 @@ static struct board_type products[] = {
 	{0x40700E11, "Smart Array 5300", &SA5_access},
 	{0x40800E11, "Smart Array 5i", &SA5B_access},
 	{0x40820E11, "Smart Array 532", &SA5B_access},
+/* controllers below this line are also supported by the hpsa driver. 
+*/ #define HPSA_BOUNDARY 0x3223103C
 	{0x40830E11, "Smart Array 5312", &SA5B_access},
 	{0x409A0E11, "Smart Array 641", &SA5_access},
 	{0x409B0E11, "Smart Array 642", &SA5_access}, @@ -125,6 +147,19 @@ static struct board_type products[] = {
 	{0x3223103C, "Smart Array P800", &SA5_access},
 	{0x3234103C, "Smart Array P400", &SA5_access},
 	{0x323D103C, "Smart Array P700m", &SA5_access},
+	{0x3241103C, "Smart Array P212", &SA5_access},
+	{0x3243103C, "Smart Array P410", &SA5_access},
+	{0x3245103C, "Smart Array P410i", &SA5_access},
+	{0x3247103C, "Smart Array P411", &SA5_access},
+	{0x3249103C, "Smart Array P812", &SA5_access},
+	{0x324A103C, "Smart Array P712m", &SA5_access},
+	{0x324B103C, "Smart Array P711m", &SA5_access},
+	{0x3250103C, "Smart Array", &SA5_access},
+	{0x3251103C, "Smart Array", &SA5_access},
+	{0x3252103C, "Smart Array", &SA5_access},
+	{0x3253103C, "Smart Array", &SA5_access},
+	{0x3254103C, "Smart Array", &SA5_access},
+
 };
 
 /* How long to wait (in milliseconds) for board to go into simple mode */ @@ -3939,9 +3974,14 @@ static int __devinit cciss_lookup_board_id(struct pci_dev *pdev, u32 *board_id)
 	*board_id = ((subsystem_device_id << 16) & 0xffff0000) |
 			subsystem_vendor_id;
 
-	for (i = 0; i < ARRAY_SIZE(products); i++)
+	for (i = 0; i < ARRAY_SIZE(products); i++) {
+		/* Stand aside for hpsa driver on request */
+		if (cciss_allow_hpsa && products[i].board_id == HPSA_BOUNDARY)
+			return -ENODEV;
+
 		if (*board_id == products[i].board_id)
 			return i;
+	}
 	dev_warn(&pdev->dev, "unrecognized board ID: 0x%08x, ignoring.\n",
 		*board_id);
 	return -ENODEV;

Is there any other patch that needs to be applied? 

Thanks,
~Saurav


-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of scameron@beardog.cce.hp.com
Sent: 30 November 2010 01:20
To: Saurav Kashyap
Cc: linux-scsi@vger.kernel.org; Vikas Chaudhary; Andrew Vasquez; Giridhar Malavali; Madhu Iyengar; Lalit Chandivade
Subject: Re: Booting problems with hpsa - 2.6.37-rc3-9

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

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

