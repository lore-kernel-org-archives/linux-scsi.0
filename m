Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADEA7C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Sep 2021 12:14:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DDF660F4A
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Sep 2021 12:14:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239291AbhIPMP1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Sep 2021 08:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239269AbhIPMP0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Sep 2021 08:15:26 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75B49C061574
        for <linux-scsi@vger.kernel.org>; Thu, 16 Sep 2021 05:14:06 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id d11so2466132ilc.8
        for <linux-scsi@vger.kernel.org>; Thu, 16 Sep 2021 05:14:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=apF5IJt+I+Tw4TG/Nb56W2gi7ydtbsqj8B5oBJp6qKI=;
        b=FskSbegYNW5xozQe986i4ol+w1laiykgrKUa61ItxCa35Qvn6IpuRzvZ5BEuQANMNH
         5baT28ii1O2jTA6QKDDAF54cMFwqkTw+i2TUWYjdPEDpD3mI4j4EyUy08YrPK9BFuRGe
         WCQW/MCIRA0WX5UevIFkN/wzipFoqdeb5OYGGaT4zLXXGLLdhdCj6DjUGuFWEnc4Dpdu
         RDHa4/w0zvEVQ1v7G7texjhyEGXNTO98avbBS0F3qYuWGmwLVg59OXwe0lhEbNQSsni2
         FlBBiTSfXx6oPRiw8PSIxd7yij1IWncoAKOhVLtTBZnaEfCtP/EWjrXQIeGJiywWkQc3
         fcgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=apF5IJt+I+Tw4TG/Nb56W2gi7ydtbsqj8B5oBJp6qKI=;
        b=H0idJUh62yz/uDNs349jJVzR68ouQI+SkVRp33/aMIQ4B8q9/EGlRJhAxgBPBK/J1C
         Z5RoCAY1ccVd4csXYQ3v4P+fXFcnFKaBk6IeLj0kCwPlHFe9CwKDj9TdV9kFSt+KQ0n0
         wXGgUPWtjrXsr6QoBwjipYUc2rRNf/nAPPgBP4ng8W9i71cYwZY/wvvGjqoiNIk36Ksz
         sJ+rFAPM4zJ8jigAEqRAlViR4Dj9GDRZsJKZUTuzewJTfEWdQpdgSocHpp4WSxkoHZn8
         RoPtZd93CNzE23sp12ZiWbPUf3Wsp2Qanz/zC6tjw+s3IB3WvDwqLJmb5Bi3/ctpukFi
         ZGSA==
X-Gm-Message-State: AOAM533dUEz7H3i7+EBop4SiWq1igG5mQj/Xv3Op8jyvhX4gA4GmXTT8
        zTaR4LBQE1snq1UmoKRromne30v2XVwE9gz5Sw==
X-Google-Smtp-Source: ABdhPJw+IW3H2tGue7kRepUKti9+zTpEFdg4OegUw6Vzcxi8vvFrcAgfBUaafChsMgf3IOqI4hW3lSffdqENSy7qTEg=
X-Received: by 2002:a92:c64a:: with SMTP id 10mr3700323ill.102.1631794445818;
 Thu, 16 Sep 2021 05:14:05 -0700 (PDT)
MIME-Version: 1.0
From:   Jinmeng Zhou <jjjinmeng.zhou@gmail.com>
Date:   Thu, 16 Sep 2021 20:13:54 +0800
Message-ID: <CAA-qYXhs-ZBc2hWoC2faT+4jRGsLd=uLAv=UqbtiuH3vZBBicg@mail.gmail.com>
Subject: sg_ioctl_common() lacks a security check before calling sg_scsi_ioctl()
To:     dgilbert@interlog.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     shenwenbosmile@gmail.com, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Dear maintainers,

hi, our team has found a missing check bug on Linux kernel v5.10.7
using static analysis.
Th function sg_ioctl_common() lacks a security check before calling
sg_scsi_ioctl().

Specifically, the checking example, scsi_ioctl_common() checks CAP_SYS_ADMIN
or CAP_SYS_RAWIO at line 6 before calling sg_scsi_ioctl() .

1.
2. static int scsi_ioctl_common(struct scsi_device *sdev, int cmd,
void __user *arg)
3. {
4. ...
5.   case SCSI_IOCTL_SEND_COMMAND:
6.     if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
7.       return -EACCES;
8.     return sg_scsi_ioctl(sdev->request_queue, NULL, 0, arg);
9. ...
10. }


In no-check function sg_ioctl_common(), sg_scsi_ioctl() is called at
line 9 without checking
CAP_SYS_ADMIN or CAP_SYS_RAWIO capability.
1.
2. static long sg_ioctl_common(struct file *filp, Sg_device *sdp, Sg_fd *sfp,
3. unsigned int cmd_in, void __user *p)
4. {
5. ...
6.   case SCSI_IOCTL_SEND_COMMAND:
7.     if (atomic_read(&sdp->detaching))
8.       return -ENODEV;
9.     return sg_scsi_ioctl(sdp->device->request_queue, NULL, filp->f_mode, p);
10. ...
11. }


sg_ioctl() calls above functions that firstly calls no-check function
sg_ioctl_common()
and then calls checking function scsi_ioctl() => scsi_ioctl_common().
However, the delayed check may cause a problem.

1. static long sg_ioctl(struct file *filp, unsigned int cmd_in,
unsigned long arg)
2. {
3. ...
4.   ret = sg_ioctl_common(filp, sdp, sfp, cmd_in, p);
5.   if (ret != -ENOIOCTLCMD)
6.     return ret;
7.   return scsi_ioctl(sdp->device, cmd_in, p);
8. }
