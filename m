From: "Lee Xing" <lxing@Crossroads.com>
Subject: An Issue related to scsi_debug and mid-layer
Date: Tue, 8 Jun 2004 17:22:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <519672568F040C41B6FAC21ADF51B18FF025@mailnode1.commstor.crossroads.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email.crossroads.com ([65.68.235.6]:3831 "HELO
	email.crossroads.com") by vger.kernel.org with SMTP id S265348AbUFHWW1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Jun 2004 18:22:27 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I'm using scsi_debug_061.tgz for lk2.4 (2.4.20-8), and find an issue with bus scan.  Can some one please take a look and see what I missed?

In order to let mid-layer scan certain numbers of channels, targets and luns, I add a pointer to Scsi_Host in scsi_debug_detect( ) of scsi_debug (v.061), so I can specify max_channel, max_id and max_lun when scsi_register(tpnt, 0) returns that pointer (see below).

static int scsi_debug_detect(Scsi_Host_Template * tpnt)
{
   struct Scsi_Host   * pSH = NULL;
	...
    for (num_present = 0, k = 0; k < NR_HOSTS_PRESENT; k++) 
    {
        pSH = scsi_register(tpnt, 0);

        if(NULL == pSH)
        {
            printk(KERN_ERR "scsi_debug_detect: "
                    "scsi_register failed k=%d\n", k);
        }
       else
        {
             ++num_present;

             pSH->max_channel = 1; /* scan bus 0 and 1 */
             pSH->max_id = 2;          /* scan target 0 and 1 */
             pSH->max_lun = 3;        /* scan lun 0, 1 and 2 */
        }
    }
  ...
}

I also add a printk in scsi_debug_queuecommand( ) so I can see which channel, target and lun the mid-layer scans.

static int scsi_debug_queuecommand(Scsi_Cmnd * SCpnt, done_funct_t done)
{
...
    if (NULL == SCpnt->device->hostdata) 
    {
        printk("<0>###### SCpnt->channel=%d    SCpnt->target=%d    SCpnt->lun=%d    before call devInfReg()\n",
                  SCpnt->channel, SCpnt->target, SCpnt->lun);

             devip = devInfoReg(SCpnt->device);

        if (NULL == devip)
        {
            return schedule_resp(SCpnt, NULL, done, DID_NO_CONNECT << 16, 0);
        }

        SCpnt->device->hostdata = devip;
    }
...
}

- Scenario 1
When using "modprobe scsi_debug scsi_debug_num_devs=4" (i.e. use 4 ramdisks), I can see mid-layer scans (channel_target_lun) 0_0_0, 0_1_0, 1_0_0 and 1_1_0.  This is good since there are just 4 "disks" to scan.  Also, "fdisk -l" shows four 8MB disks are added (/dev/sda, sdb, sdc, sdd).

- Scenario 2
When using "modprobe scsi_debug scsi_debug_num_devs=8", mid-layer scans 0_0_0, 0_1_0, 1_0_0, 1_1_0 once, then scan  0_0_0, 0_1_0, 1_0_0, 1_1_0 for the 2nd time.  "fdisk -l" show eight 8MB "disks" are added (/dev/sda ~ sdh).

My question is why mid-layer scans the specified channel, target lun twice, and create twice as many sd devices as available ones?  Is it mid-layer's issue or scsi_debug's, or maybe I missed something?

Thanks,


Lee 

