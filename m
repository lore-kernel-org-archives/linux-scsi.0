Return-Path: <SRS0=/Ihf=62=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73643C54E4A
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 10:31:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5221E206DD
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 10:31:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ibqt49sM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729499AbgELKbh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 May 2020 06:31:37 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49974 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729422AbgELKbh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 May 2020 06:31:37 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04CAN3ZS182980;
        Tue, 12 May 2020 10:31:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=QzRGpNJ7TDhVyYXa0PmJm+XxBrI5lZJdmLRxaDVFRKs=;
 b=ibqt49sMpkKiMdyvysIqZWjqI7WJkVxNMogqSRafPzwVcwz3Ap3A5kNEmFCs3Jqs1+c/
 q7jn7dBLAECVAV7bl5y3jpUspzuussCtRJm4SofWDyd6PNlZ3X1YBLuAIdWiL4cU19IW
 Vy44SzhaT1SYC/Gc5B6IihID6wlZy5Obmy0PUQL7tW9//EytC25rMOL0Hy0WA/cMTIMG
 ug1TsLtVlDc4r2ygCqilxc0iTCZfmJOA3AqNOkr2uqYuB/pzv2ulFjqpadIiy1p1ZFcn
 DVtGPrE9g+vdsdpNApVVwUkWBQlFsje5LWnDnHiSIEATsh0VULqsdFTN7oXNP2lWAcXN YA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 30x3mbt5c2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 12 May 2020 10:31:31 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04CAOMFb032956;
        Tue, 12 May 2020 10:31:31 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 30x69sxr93-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 May 2020 10:31:31 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04CAVUrF010237;
        Tue, 12 May 2020 10:31:30 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 May 2020 03:31:29 -0700
Date:   Tue, 12 May 2020 13:31:23 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     dgilbert@interlog.com
Cc:     linux-scsi@vger.kernel.org
Subject: [bug report] scsi: scsi_debug: Add per_host_store option
Message-ID: <20200512103123.GA261906@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9618 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 adultscore=0
 spamscore=0 suspectscore=3 mlxscore=0 mlxlogscore=996 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005120078
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9618 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 impostorscore=0
 mlxscore=0 suspectscore=3 bulkscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005120078
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Douglas Gilbert,

The patch 87c715dcde63: "scsi: scsi_debug: Add per_host_store option"
from Apr 21, 2020, leads to the following static checker warning:

drivers/scsi/scsi_debug.c:3748 resp_write_same() warn: inconsistent returns '*macc_lckp'.
  Locked on  : 3728
  Unlocked on: 3708,3748
drivers/scsi/scsi_debug.c:3712 resp_write_same() error: we previously assumed 'sip' could be null (see line 3699)
drivers/scsi/scsi_debug.c:3902 resp_comp_write() error: we previously assumed 'sip' could be null (see line 3859)
drivers/scsi/scsi_debug.c:3965 resp_unmap() error: we previously assumed 'sip' could be null (see line 3926)
drivers/scsi/scsi_debug.c:4261 resp_verify() error: we previously assumed 'sip' could be null (see line 4208)


drivers/scsi/scsi_debug.c
  3688  static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
  3689                             u32 ei_lba, bool unmap, bool ndob)
  3690  {
  3691          struct scsi_device *sdp = scp->device;
  3692          struct sdebug_dev_info *devip = (struct sdebug_dev_info *)sdp->hostdata;
  3693          unsigned long long i;
  3694          u64 block, lbaa;
  3695          u32 lb_size = sdebug_sector_size;
  3696          int ret;
  3697          struct sdeb_store_info *sip = devip2sip((struct sdebug_dev_info *)
  3698                                                  scp->device->hostdata);
  3699          rwlock_t *macc_lckp = sip ? &sip->macc_lck : &sdeb_fake_rw_lck;
                          ^^^^^^^^^
If "sip" is non-NULL we use that lock.

  3700          u8 *fs1p;
  3701          u8 *fsp;
  3702  
  3703          write_lock(macc_lckp);
  3704  
  3705          ret = check_device_access_params(scp, lba, num, true);
  3706          if (ret) {
  3707                  write_unlock(macc_lckp);
  3708                  return ret;
  3709          }
  3710  
  3711          if (unmap && scsi_debug_lbp()) {
  3712                  unmap_region(sip, lba, num);

How do we know "sip" is non-NULL?

  3713                  goto out;
  3714          }
  3715          lbaa = lba;
  3716          block = do_div(lbaa, sdebug_store_sectors);
  3717          /* if ndob then zero 1 logical block, else fetch 1 logical block */
  3718          fsp = sip->storep;
                      ^^^^^^^^^^^
Same.

  3719          fs1p = fsp + (block * lb_size);
  3720          if (ndob) {
  3721                  memset(fs1p, 0, lb_size);
  3722                  ret = 0;
  3723          } else
  3724                  ret = fetch_to_dev_buffer(scp, fs1p, lb_size);
  3725  
  3726          if (-1 == ret) {
  3727                  write_unlock(&sip->macc_lck);

If we know that "sip" is non-NULL then this is fine, but it is probably
less confusing to use write_unlock(macc_lckp); consistently everywhere.

  3728                  return DID_ERROR << 16;
  3729          } else if (sdebug_verbose && !ndob && (ret < lb_size))
  3730                  sdev_printk(KERN_INFO, scp->device,
  3731                              "%s: %s: lb size=%u, IO sent=%d bytes\n",
  3732                              my_name, "write same", lb_size, ret);

regards,
dan carpenter
