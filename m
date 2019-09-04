Return-Path: <SRS0=LwoI=W7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 814A7C3A5AA
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 15:58:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 636A3238C5
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 15:58:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731960AbfIDP6Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Sep 2019 11:58:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49160 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731943AbfIDP6Y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 4 Sep 2019 11:58:24 -0400
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5D76369060
        for <linux-scsi@vger.kernel.org>; Wed,  4 Sep 2019 15:58:23 +0000 (UTC)
Received: by mail-qk1-f199.google.com with SMTP id b143so23581757qkg.9
        for <linux-scsi@vger.kernel.org>; Wed, 04 Sep 2019 08:58:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eXhUx0g+gI+jZJyOCbnFK1ECh9j/pVvjy8eykM7p8ms=;
        b=bnvywFTHRevFW8t7WRncEYKuS/CHZA0AyzTtJGhczw2+Q72l7ZWnO06kOtbSF1IthI
         xBJikSq/P8pdjoOYsH2TkYz06B26xzNWxLzmQuxtNo3vkkTZ23QDwKhuzCNPhSmd5TzO
         BhGWRLv6BMVxma0SLZF1vzmfWcOb2DxSr0V8Y9eQPgmMNJs5UhGqyNeD9rEw8K/fVY0b
         iOn8HOjO9bXx7aSS/pOuiEtyQNlDzJ3Hasnu9aZPbWSNnvCTNsdLMJqkfEyawbF6p5XQ
         KmBbYyzQBNHNj6ZVOLqSfa5CFJa0eQ9QPyxxrTAtAdLNCQAWxWAOZsEyRH3PdMutAr5/
         Zzcg==
X-Gm-Message-State: APjAAAU9PSy8kG32f5Nn4ZXTI+mFy8qn9vaoUHuYqmJSIuU20Wh1aqXL
        2YWh8vAdzdLIS3T8EFLI1LN01XPOA+KrWJmGXfg6gUnIpzNlT0DapcA7VF+ujATPYBRp3Q+X8eH
        CVUJ1I4BqMsgplwmssx9+gA==
X-Received: by 2002:a05:6214:1808:: with SMTP id o8mr13870662qvw.118.1567612702382;
        Wed, 04 Sep 2019 08:58:22 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwVXQzPpcu++S3SEebYwLYQGeFnfpEr4BzlJ6KPWo1yaOS8IFwwP8BHgAsS0Ko6Ki39tQdB2Q==
X-Received: by 2002:a05:6214:1808:: with SMTP id o8mr13870630qvw.118.1567612701949;
        Wed, 04 Sep 2019 08:58:21 -0700 (PDT)
Received: from rhel7lobe ([2600:6c64:4e80:f1:aa45:cafe:5682:368f])
        by smtp.gmail.com with ESMTPSA id k199sm3739020qke.45.2019.09.04.08.58.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Sep 2019 08:58:20 -0700 (PDT)
Message-ID: <44432aec71a7607aec9bcbd05ebf1fc05d9788e2.camel@redhat.com>
Subject: Re: [Bug 204769] New: SCSI devices missing for disks attached to
 controller
From:   Laurence Oberman <loberman@redhat.com>
To:     bugzilla-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org
Date:   Wed, 04 Sep 2019 11:58:19 -0400
In-Reply-To: <bug-204769-11613@https.bugzilla.kernel.org/>
References: <bug-204769-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2019-09-04 at 15:18 +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=204769
> 
>             Bug ID: 204769
>            Summary: SCSI devices missing for disks attached to
> controller
>            Product: SCSI Drivers
>            Version: 2.5
>     Kernel Version: 5.12.11
>           Hardware: Intel
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: AACRAID
>           Assignee: scsi_drivers-aacraid@kernel-bugs.osdl.org
>           Reporter: linux@lanrules.de
>         Regression: No
> 
> We use an Adaptec ASR8405 RAID controller with LSI backplane. The
> RAID
> controller is configured to expose attached disks to the system
> ("Expose RAW").
> 
> Up to Linux 5.1.12, devices would show as expected. lsscsi -v
> reports:
> > [0:0:0:0]    disk    ASR8405  storage          V1.0  /dev/sda
> >   dir: /sys/bus/scsi/devices/0:0:0:0 
> >  
> > [/sys/devices/pci0000:60/0000:60:03.1/0000:61:00.0/host0/target0:0:
> > 0/0:0:0:0]
> > [0:1:4:0]    disk    ATA      HGST HUH721212AL T3D0  -
> >   dir: /sys/bus/scsi/devices/0:1:4:0 
> >  
> > [/sys/devices/pci0000:60/0000:60:03.1/0000:61:00.0/host0/target0:1:
> > 4/0:1:4:0]
> > [0:1:5:0]    disk    ATA      HGST HUH721212AL T3D0  -
> >   dir: /sys/bus/scsi/devices/0:1:5:0 
> >  
> > [/sys/devices/pci0000:60/0000:60:03.1/0000:61:00.0/host0/target0:1:
> > 5/0:1:5:0]
> > [0:1:6:0]    disk    ATA      HGST HUH721212AL T3D0  -
> >   dir: /sys/bus/scsi/devices/0:1:6:0 
> >  
> > [/sys/devices/pci0000:60/0000:60:03.1/0000:61:00.0/host0/target0:1:
> > 6/0:1:6:0]
> > [0:1:7:0]    disk    ATA      HGST HUH721212AL T3D0  -
> >   dir: /sys/bus/scsi/devices/0:1:7:0 
> >  
> > [/sys/devices/pci0000:60/0000:60:03.1/0000:61:00.0/host0/target0:1:
> > 7/0:1:7:0]
> > [0:1:8:0]    disk    ATA      HGST HUH721212AL T3D0  -
> >   dir: /sys/bus/scsi/devices/0:1:8:0 
> >  
> > [/sys/devices/pci0000:60/0000:60:03.1/0000:61:00.0/host0/target0:1:
> > 8/0:1:8:0]
> > [0:1:9:0]    disk    ATA      HGST HUH721212AL T3D0  -
> >   dir: /sys/bus/scsi/devices/0:1:9:0 
> >  
> > [/sys/devices/pci0000:60/0000:60:03.1/0000:61:00.0/host0/target0:1:
> > 9/0:1:9:0]
> > [0:1:10:0]   disk    ATA      HGST HUH721212AL T3D0  -
> >   dir: /sys/bus/scsi/devices/0:1:10:0 
> >  
> > [/sys/devices/pci0000:60/0000:60:03.1/0000:61:00.0/host0/target0:1:
> > 10/0:1:10:0]
> > [0:1:11:0]   disk    ATA      HGST HUH721212AL T3D0  -
> >   dir: /sys/bus/scsi/devices/0:1:11:0 
> >  
> > [/sys/devices/pci0000:60/0000:60:03.1/0000:61:00.0/host0/target0:1:
> > 11/0:1:11:0]
> > [0:1:12:0]   disk    ATA      HGST HUH721212AL T3D0  -
> >   dir: /sys/bus/scsi/devices/0:1:12:0 
> >  
> > [/sys/devices/pci0000:60/0000:60:03.1/0000:61:00.0/host0/target0:1:
> > 12/0:1:12:0]
> > [0:1:13:0]   disk    ATA      HGST HUH721212AL T3D0  -
> >   dir: /sys/bus/scsi/devices/0:1:13:0 
> >  
> > [/sys/devices/pci0000:60/0000:60:03.1/0000:61:00.0/host0/target0:1:
> > 13/0:1:13:0]
> > [0:3:0:0]    enclosu LSI      SAS3x36          0601  -
> >   dir: /sys/bus/scsi/devices/0:3:0:0 
> >  
> > [/sys/devices/pci0000:60/0000:60:03.1/0000:61:00.0/host0/target0:3:
> > 0/0:3:0:0]
> > [N:0:4:1]    dsk/nvm Samsung SSD 970 PRO
> > 1TB__1                 /dev/nvme0n1
> >   dir: /sys/class/nvme/nvme0/nvme0n1 
> >  
> > [/sys/devices/pci0000:10/0000:10:01.3/0000:13:00.0/nvme/nvme0/nvme0
> > n1]
> > [N:1:4:1]    dsk/nvm Samsung SSD 970 PRO
> > 1TB__1                 /dev/nvme1n1
> >   dir: /sys/class/nvme/nvme1/nvme1n1 
> >  
> > [/sys/devices/pci0000:10/0000:10:01.4/0000:14:00.0/nvme/nvme1/nvme1
> > n1]
> 
> On Linux 5.12.11, the devices are missing. lsscsi -v reports:
> > [0:0:0:0]    disk    ASR8405  storage          V1.0  /dev/sda
> >   dir: /sys/bus/scsi/devices/0:0:0:0 
> >  
> > [/sys/devices/pci0000:60/0000:60:03.1/0000:61:00.0/host0/target0:0:
> > 0/0:0:0:0]
> > [0:3:0:0]    enclosu LSI      SAS3x36          0601  -
> >   dir: /sys/bus/scsi/devices/0:3:0:0 
> >  
> > [/sys/devices/pci0000:60/0000:60:03.1/0000:61:00.0/host0/target0:3:
> > 0/0:3:0:0]
> > [N:1:4:1]    dsk/nvm Samsung SSD 970 PRO
> > 1TB__1                 /dev/nvme1n1
> >   dir: /sys/class/nvme/nvme0/nvme1n1 
> >  
> > [/sys/devices/pci0000:10/0000:10:01.3/0000:13:00.0/nvme/nvme0/nvme1
> > n1]
> > [N:0:4:1]    dsk/nvm Samsung SSD 970 PRO
> > 1TB__1                 /dev/nvme0n1
> >   dir: /sys/class/nvme/nvme1/nvme0n1 
> >  
> > [/sys/devices/pci0000:10/0000:10:01.4/0000:14:00.0/nvme/nvme1/nvme0
> > n1]
> 
> Output in dmesg is basically the same, except that the following
> lines are
> missing with the newer kernel:
> 
> > [   17.016661] scsi 0:1:4:0: Direct-Access     ATA      HGST
> > HUH721212AL T3D0
> > PQ: 1 ANSI: 6
> > [   17.018313] scsi 0:1:5:0: Direct-Access     ATA      HGST
> > HUH721212AL T3D0
> > PQ: 1 ANSI: 6
> > [   17.020129] scsi 0:1:6:0: Direct-Access     ATA      HGST
> > HUH721212AL T3D0
> > PQ: 1 ANSI: 6
> > [   17.022530] scsi 0:1:7:0: Direct-Access     ATA      HGST
> > HUH721212AL T3D0
> > PQ: 1 ANSI: 6
> > [   17.024291] scsi 0:1:8:0: Direct-Access     ATA      HGST
> > HUH721212AL T3D0
> > PQ: 1 ANSI: 6
> > [   17.026041] scsi 0:1:9:0: Direct-Access     ATA      HGST
> > HUH721212AL T3D0
> > PQ: 1 ANSI: 6
> > [   17.027725] scsi 0:1:10:0: Direct-Access     ATA      HGST
> > HUH721212AL
> > T3D0 PQ: 1 ANSI: 6
> > [   17.029395] scsi 0:1:11:0: Direct-Access     ATA      HGST
> > HUH721212AL
> > T3D0 PQ: 1 ANSI: 6
> > [   17.031145] scsi 0:1:12:0: Direct-Access     ATA      HGST
> > HUH721212AL
> > T3D0 PQ: 1 ANSI: 6
> > [   17.032672] scsi 0:1:13:0: Direct-Access     ATA      HGST
> > HUH721212AL
> > T3D0 PQ: 1 ANSI: 6
> 
> The only change on the system to obtain the different behavior is
> upgrade/downgrade of the kernel via kexec.

So the driver is loading as /dev/sda is being seen above.
Seems likely to be the enclosure then that is not being probed
[0:0:0:0]    disk    ASR8405  storage          V1.0  /dev/sda 
The enclosure looks like its on another port correct ?
0:1:x:x

I am looking at what may have changed in the latest commits
> 

