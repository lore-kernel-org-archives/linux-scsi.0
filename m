From: Jason L Tibbitts III <tibbs@math.uh.edu>
Subject: Re: [REGRESSION] 28676d869bbb (scsi: sg: check for valid direction before starting the request) breaks mtx tape library control
Date: Fri, 21 Jul 2017 14:23:16 -0500
Message-ID: <ufa7ez18uhn.fsf@epithumia.math.uh.edu>
References: <ufafudubmkd.fsf@epithumia.math.uh.edu>
        <20170718073747.GD4875@linux-x5ow.site>
        <ufak235abug.fsf@epithumia.math.uh.edu>
        <20170719070335.GC4151@linux-x5ow.site>
        <ufazic0974h.fsf@epithumia.math.uh.edu>
        <20170719083654.GE4151@linux-x5ow.site>
        <20170721164343.GA4086@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170721164343.GA4086@linux-x5ow.site> (Johannes Thumshirn's
        message of "Fri, 21 Jul 2017 18:43:43 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, dvyukov@google.com, hare@suse.com, hch@lst.de, martin.petersen@oracle.com, jth@kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "JT" == Johannes Thumshirn <jthumshirn@suse.de> writes:

JT> Jason, can you try the above? If it works and Doug doesn't respond,
JT> I'm inclined yo submit this band aid.

Unfortunately it doesn't appear to work for me.  Maybe I'm building the
wrong thing, though.  I checked out 4.12, cherry picked
68c59fcea1f2c6a54c62aa896cc623c1b5bc9b47 and then applied your one liner
on top of that.  There appears to be no change in behavior:

[root@backup2 ~]# mtx -f /dev/sg7 next 0
Unloading drive 0 into Storage Element 47...mtx: Request Sense: Long
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
MOVE MEDIUM from Element Address 1 to 1047 Failed

I can also apply the debugging patch and try again if that would give
you more useful information.

 - J<
