From: Jason L Tibbitts III <tibbs@math.uh.edu>
Subject: Re: [REGRESSION] 28676d869bbb (scsi: sg: check for valid direction before starting the request) breaks mtx tape library control
Date: Wed, 19 Jul 2017 03:13:34 -0500
Message-ID: <ufazic0974h.fsf@epithumia.math.uh.edu>
References: <ufafudubmkd.fsf@epithumia.math.uh.edu>
        <20170718073747.GD4875@linux-x5ow.site>
        <ufak235abug.fsf@epithumia.math.uh.edu>
        <20170719070335.GC4151@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170719070335.GC4151@linux-x5ow.site> (Johannes Thumshirn's
        message of "Wed, 19 Jul 2017 09:03:35 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, dvyukov@google.com, hare@suse.com, hch@lst.de, martin.petersen@oracle.com
List-Id: linux-scsi@vger.kernel.org

>>>>> "JT" == Johannes Thumshirn <jthumshirn@suse.de> writes:

JT> Can you please apply this debugging patch, so I can see what's going
JT> on.

Sure, no problem.

I generally run "mtx -f /dev/sg7 status" first just to make sure the
library is there; this has always worked as expected.  With the debug
patch applied, this is sent to the console:
[   33.933422] sg_is_valid_dxfer: dxfer_direction: -3, dxfer_len: 56
[   33.940526] sg_is_valid_dxfer: dxfer_direction: -3, dxfer_len: 136
[   33.982429] sg_is_valid_dxfer: dxfer_direction: -3, dxfer_len: 4240
[   34.569986] sg_is_valid_dxfer: dxfer_direction: -3, dxfer_len: 4240
[   34.623898] sg_is_valid_dxfer: dxfer_direction: -3, dxfer_len: 4240

Then running "mtx -f /dev/sg7 next 0" gives this as stdout/err:

Unloading drive 0 into Storage Element 46...mtx: Request Sense: Long
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
MOVE MEDIUM from Element Address 1 to 1046 Failed

And this to the console:
[   45.552524] sg_is_valid_dxfer: dxfer_direction: -3, dxfer_len: 56
[   45.559626] sg_is_valid_dxfer: dxfer_direction: -3, dxfer_len: 136
[   45.603544] sg_is_valid_dxfer: dxfer_direction: -3, dxfer_len: 4240
[   46.204614] sg_is_valid_dxfer: dxfer_direction: -3, dxfer_len: 4240
[   46.258463] sg_is_valid_dxfer: dxfer_direction: -3, dxfer_len: 4240
[   46.304530] sg_is_valid_dxfer: dxfer_direction: -2, dxfer_len: 0

Would you also want to see the output from that patch applied to a
functioning kernel?

 - J<
