From: Jason L Tibbitts III <tibbs@math.uh.edu>
Subject: Re: [REGRESSION] 28676d869bbb (scsi: sg: check for valid direction before starting the request) breaks mtx tape library control
Date: Tue, 18 Jul 2017 12:33:59 -0500
Message-ID: <ufak235abug.fsf@epithumia.math.uh.edu>
References: <ufafudubmkd.fsf@epithumia.math.uh.edu>
        <20170718073747.GD4875@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170718073747.GD4875@linux-x5ow.site> (Johannes Thumshirn's
        message of "Tue, 18 Jul 2017 09:37:47 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, dvyukov@google.com, hare@suse.com, hch@lst.de, martin.petersen@oracle.com
List-Id: linux-scsi@vger.kernel.org

I have verified that building a clean v4.12 with
68c59fcea1f2c6a54c62aa896cc623c1b5bc9b47 cherry picked on top still
shows the problem:

[root@backup2 ~]# mtx -f /dev/sg7 next 0
Unloading drive 0 into Storage Element 45...mtx: Request Sense: Long
Report=yes
mtx: Request Sense: Valid Residual=no
mtx: Request Sense: Error Code=0 (Unknown?!)
mtx: Request Sense: Sense Key=No Sense
mtx: Request Sense: FileMark=no
mtx: Request Sense: EOM=no
mtx: Request Sense: ILI=no
mtx: Request Sense: Additional Sense Code = 00
mtx: Request Sense: Additional Sense Qualifier = 00
mtx: Request Sense: BPV=no
mtx: Request Sense: Error in CDB=no
mtx: Request Sense: SKSV=no
MOVE MEDIUM from Element Address 1 to 1045 Failed

Nothing appears to be logged; is there any kind of debugging information
I can collect which might help to track this down?  I'm not particularly
good at this but I am pretty sure that I'm building everything properly
and am actually booting the patched kernel.

 - J<
