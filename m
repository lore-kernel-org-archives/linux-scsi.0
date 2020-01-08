Return-Path: <SRS0=fkLW=25=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CC5DC33CA2
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jan 2020 16:03:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 631452070E
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jan 2020 16:03:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728496AbgAHQDK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jan 2020 11:03:10 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:65408 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728249AbgAHQDK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jan 2020 11:03:10 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 008FqPMn024346;
        Wed, 8 Jan 2020 11:01:35 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2xdeb0175d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jan 2020 11:01:34 -0500
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 008FqmrH025627;
        Wed, 8 Jan 2020 11:01:33 -0500
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2xdeb0173y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jan 2020 11:01:33 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 008G0Z9H022584;
        Wed, 8 Jan 2020 16:01:31 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma03wdc.us.ibm.com with ESMTP id 2xajb6nnq1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jan 2020 16:01:31 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 008G1U4747972824
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Jan 2020 16:01:30 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D229EBE053;
        Wed,  8 Jan 2020 16:01:30 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B7C77BE051;
        Wed,  8 Jan 2020 16:01:28 +0000 (GMT)
Received: from jarvis.ext.hansenpartnership.com (unknown [9.85.182.239])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  8 Jan 2020 16:01:28 +0000 (GMT)
Message-ID: <1578499287.3260.7.camel@linux.ibm.com>
Subject: Re: [PATCH v1] driver core: Use list_del_init to replace list_del
 at device_links_purge()
From:   James Bottomley <jejb@linux.ibm.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     John Garry <john.garry@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>, saravanak@google.com,
        linux-kernel@vger.kernel.org, linuxarm@huawei.com,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Date:   Wed, 08 Jan 2020 08:01:27 -0800
In-Reply-To: <20200108155700.GA2459586@kroah.com>
References: <1578483244-50723-1-git-send-email-luojiaxing@huawei.com>
         <20200108122658.GA2365903@kroah.com>
         <73252c08-ac46-5d0d-23ec-16c209bd9b9a@huawei.com>
         <1578498695.3260.5.camel@linux.ibm.com>
         <20200108155700.GA2459586@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-08_04:2020-01-08,2020-01-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 adultscore=0 clxscore=1015
 lowpriorityscore=0 impostorscore=0 phishscore=0 mlxlogscore=876
 spamscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001080130
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2020-01-08 at 16:57 +0100, Greg KH wrote:
> On Wed, Jan 08, 2020 at 07:51:35AM -0800, James Bottomley wrote:
> > On Wed, 2020-01-08 at 14:50 +0000, John Garry wrote:
> > > On 08/01/2020 12:26, Greg KH wrote:
> > > > On Wed, Jan 08, 2020 at 07:34:04PM +0800, Luo Jiaxing wrote:
> > > > > We found that enabling kernel compilation options
> > > > > CONFIG_SCSI_ENCLOSURE and
> > > > > CONFIG_ENCLOSURE_SERVICES, repeated initialization and
> > > > > deletion
> > > > > of the same
> > > > > SCSI device will cause system panic, as follows:
> > > > > [72.425705] Unable to handle kernel paging request at virtual
> > > > > address
> > > > > dead000000000108
> > > > > ...
> > > > > [72.595093] Call trace:
> > > > > [72.597532] device_del + 0x194 / 0x3a0
> > > > > [72.601012] enclosure_remove_device + 0xbc / 0xf8
> > > > > [72.605445] ses_intf_remove + 0x9c / 0xd8
> > > > > [72.609185] device_del + 0xf8 / 0x3a0
> > > > > [72.612576] device_unregister + 0x14 / 0x30
> > > > > [72.616489] __scsi_remove_device + 0xf4 / 0x140
> > > > > [72.620747] scsi_remove_device + 0x28 / 0x40
> > > > > [72.624745] scsi_remove_target + 0x1c8 / 0x220
> > > > > 
> > > > > After analysis, we see that in the error scenario, the ses
> > > > > module
> > > > > has the
> > > > > following calling sequence:
> > > > > device_register() -> device_del() -> device_add() ->
> > > > > device_del().
> > > > > The first call to device_del() is fine, but the second call
> > > > > to
> > > > > device_del()
> > > > > will cause a system panic.
> > > > 
> > > > Is this all on the same device structure?  If so, that's not
> > > > ok,
> > > > you
> > > > can't do that, once device_del() is called on the memory
> > > > location,
> > > > you
> > > > can not call device_add() on it again.
> > > > 
> > > > How are you triggering this from userspace?
> > > 
> > > This can be triggered by causing the SCSI device to be lost,
> > > found,
> > > and 
> > > lost again:
> > > 
> > > root@(none)$ pwd
> > > /sys/class/sas_phy/phy-0:0:2
> > > root@(none)$ echo 0 > enable
> > > [   48.828139] sas: smp_execute_task_sg: task to dev
> > > 500e004aaaaaaa1f 
> > > response: 0x0 status 0x2
> > > root@(none)$
> > > [   48.837040] sas: ex 500e004aaaaaaa1f phy02 change count has
> > > changed
> > > [   48.846961] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> > > [   48.852120] sd 0:0:0:0: [sda] Synchronize Cache(10) failed:
> > > Result: 
> > > hostbyte=0x04 driverbyte=0x00
> > > [   48.898111] hisi_sas_v3_hw 0000:74:02.0: dev[2:1] is gone
> > > 
> > > root@(none)$ echo 1 > enable
> > > root@(none)$
> > > [   51.967416] sas: ex 500e004aaaaaaa1f phy02 change count has
> > > changed
> > > [   51.974022] hisi_sas_v3_hw 0000:74:02.0: dev[7:1] found
> > > [   51.991305] scsi 0:0:5:0: Direct-
> > > Access     SEAGATE  ST2000NM0045 
> > > N004 PQ: 0 ANSI: 6
> > > [   52.003609] sd 0:0:5:0: [sda] 3907029168 512-byte logical
> > > blocks: 
> > > (2.00 TB/1.82 TiB)
> > > [   52.012010] sd 0:0:5:0: [sda] Write Protect is off
> > > [   52.022643] sd 0:0:5:0: [sda] Write cache: enabled, read
> > > cache: 
> > > enabled, supports DPO and FUA
> > > [   52.052429]  sda: sda1
> > > [   52.064439] sd 0:0:5:0: [sda] Attached SCSI disk
> > > 
> > > root@(none)$ echo 0 > enable
> > > [   54.112100] sas: smp_execute_task_sg: task to dev
> > > 500e004aaaaaaa1f 
> > > response: 0x0 status 0x2
> > > root@(none)$ [   54.120909] sas: ex 500e004aaaaaaa1f phy02 change
> > > count 
> > > has changed
> > > [   54.130202] Unable to handle kernel paging request at virtual
> > > address 
> > > dead000000000108
> > > [   54.138110] Mem abort info:
> > > [   54.140892]   ESR = 0x96000044
> > > [   54.143936]   EC = 0x25: DABT (current EL), IL = 32 bits
> > > [   54.149236]   SET = 0, FnV = 0
> > > [   54.152278]   EA = 0, S1PTW = 0
> > > [   54.155408] Data abort info:
> > > [   54.158275]   ISV = 0, ISS = 0x00000044
> > > [   54.162098]   CM = 0, WnR = 1
> > > [   54.165055] [dead000000000108] address between user and
> > > kernel 
> > > address ranges
> > > [   54.172179] Internal error: Oops: 96000044 [#1] PREEMPT SMP
> > > [   54.177737] Modules linked in:
> > > [   54.180780] CPU: 5 PID: 741 Comm: kworker/u192:2 Not tainted 
> > > 5.5.0-rc5-dirty #1535
> > > [   54.188334] Hardware name: Huawei D06 /D06, BIOS Hisilicon D06
> > > UEFI 
> > > RC0 - V1.16.01 03/15/2019
> > > [   54.196847] Workqueue: 0000:74:02.0_disco_q
> > > sas_revalidate_domain
> > > [   54.202927] pstate: 60c00009 (nZCv daif +PAN +UAO)
> > > [   54.207705] pc : device_del+0x194/0x398
> > > [   54.211527] lr : device_del+0x190/0x398
> > > [   54.215349] sp : ffff80001cc7bb20
> > > [   54.218650] x29: ffff80001cc7bb20 x28: ffff0023be042188
> > > [   54.223948] x27: ffff0023c04c0000 x26: ffff0023be042000
> > > [   54.229246] x25: ffff8000119f0f30 x24: ffff0023be268a30
> > > [   54.234544] x23: ffff0023be268018 x22: ffff800011879000
> > > [   54.239842] x21: ffff8000119f0000 x20: ffff8000119f06e0
> > > [   54.245140] x19: ffff0023be268990 x18: 0000000000000004
> > > [   54.250438] x17: 0000000000000007 x16: 0000000000000001
> > > [   54.255736] x15: ffff0023eac13610 x14: ffff0023eb74a7f8
> > > [   54.261034] x13: 0000000000000000 x12: ffff0023eac13610
> > > [   54.266332] x11: ffff0023eb74a6c8 x10: 0000000000000000
> > > [   54.271630] x9 : ffff0023eac13618 x8 : 0000000040040000
> > > [   54.276928] x7 : 0000000000000000 x6 : ffff0023be268a90
> > > [   54.282226] x5 : ffff0023be74aa00 x4 : 0000000000000000
> > > [   54.287524] x3 : ffff8000119f0f30 x2 : dead000000000100
> > > [   54.292821] x1 : dead000000000122 x0 : 0000000000000000
> > > [   54.298119] Call trace:
> > > [   54.300553]  device_del+0x194/0x398
> > > [   54.304030]  enclosure_remove_device+0xb4/0x100
> > > [   54.308548]  ses_intf_remove+0x98/0xd8
> > > [   54.312283]  device_del+0xfc/0x398
> > > [   54.315671]  device_unregister+0x14/0x30
> > > [   54.319580]  __scsi_remove_device+0xf0/0x130
> > > [   54.323836]  scsi_remove_device+0x28/0x40
> > > [   54.327832]  scsi_remove_target+0x1bc/0x250
> > > [   54.332002]  sas_rphy_remove+0x5c/0x60
> > > [   54.335738]  sas_rphy_delete+0x14/0x28
> > > [   54.339473]  sas_destruct_devices+0x5c/0x98
> > > [   54.343642]  sas_revalidate_domain+0xa0/0x178
> > > [   54.347986]  process_one_work+0x1e0/0x358
> > > [   54.351982]  worker_thread+0x40/0x488
> > > [   54.355631]  kthread+0x118/0x120
> > > [   54.358846]  ret_from_fork+0x10/0x18
> > > [   54.362410] Code: 91028278 aa1903e0 9415f01f a94c0662
> > > (f9000441)
> > > [   54.368489] ---[ end trace 38c672fcf89c95f7 ]---
> > > 
> > > I tested on v5.4 and no such issue, but maybe the driver core
> > > changes 
> > > have exposed a ses/enclosure issue.
> > > 
> > > Checking:
> > > 
> > > int enclosure_remove_device(struct enclosure_device *edev, struct
> > > device 
> > > *dev)
> > > {
> > > 	struct enclosure_component *cdev;
> > > 	int i;
> > > 
> > > 	if (!edev || !dev)
> > > 		return -EINVAL;
> > > 
> > > 	for (i = 0; i < edev->components; i++) {
> > > 		cdev = &edev->component[i];
> > > 		if (cdev->dev == dev) {
> > > 			enclosure_remove_links(cdev);
> > > 			device_del(&cdev->cdev);
> > > 			put_device(dev);
> > > 			cdev->dev = NULL;
> > > 			return device_add(&cdev->cdev);
> > > 		}
> > > 	}
> > > 	return -ENODEV;
> > > }
> > 
> > The design of the code is simply to remove the link to the inserted
> > device which has been removed.
> > 
> > I *think* this means the calls to device_del and device_add are
> > unnecessary and should go.  enclosure_remove_links and the put of
> > the
> > enclosed device should be sufficient.
> 
> That would make more sense than trying to "reuse" the device
> structure
> here by tearing it down and adding it back.

OK, let's try that.  This should be the patch if someone can try it
(I've compile tested it, but the enclosure system is under a heap of
stuff in the garage).

James

---

diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
index 6d27ccfe0680..3c2d405bc79b 100644
--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -406,10 +406,9 @@ int enclosure_remove_device(struct enclosure_device *edev, struct device *dev)
 		cdev = &edev->component[i];
 		if (cdev->dev == dev) {
 			enclosure_remove_links(cdev);
-			device_del(&cdev->cdev);
 			put_device(dev);
 			cdev->dev = NULL;
-			return device_add(&cdev->cdev);
+			return 0;
 		}
 	}
 	return -ENODEV;
