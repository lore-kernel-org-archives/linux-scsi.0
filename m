From: Quinn Tran <quinn.tran@qlogic.com>
Subject: Re: [PATCH v2 15/16] qla2xxx: Add bulk send for atio & ctio
 completion paths.
Date: Mon, 4 Jan 2016 18:27:58 +0000
Message-ID: <D2AFECA4.1BF9A%quinn.tran@qlogic.com>
References: <1450382231-4259-1-git-send-email-himanshu.madhani@qlogic.com>
 <1450382231-4259-16-git-send-email-himanshu.madhani@qlogic.com>
 <1450682033.25674.44.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1450682033.25674.44.camel@haakon3.risingtidesystems.com>
Content-Language: en-US
Content-ID: <0FCF18F86B792A4989F9B0B486300375@qlogic.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, Giridhar Malavali <giridhar.malavali@qlogic.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org





On 12/20/15, 11:13 PM, "target-devel-owner@vger.kernel.org on behalf of
Nicholas A. Bellinger" <target-devel-owner@vger.kernel.org on behalf of
nab@linux-iscsi.org> wrote:

>On Thu, 2015-12-17 at 14:57 -0500, Himanshu Madhani wrote:
>> From: Quinn Tran <quinn.tran@qlogic.com>
>>=20
>> At high traffic, the work queue can become a bottle neck.
>> Instead of putting each command on the work queue as 1 work
>> element, the fix would daisy chain a list of commands that came
>> from FW/interrupt under 1 work element to reduce lock contention.
>>=20
>
>I'm wondering if we are better served by turning this into generic log=
ic
>in kernel/workqueue.c to be used beyond qla2xxx, or:

QT> For every work element, the pool->lock is grabbed.  Unless the lock
can be grab 1 time and the rest of the work elements piggy back on it t=
hen
it=B9s worth it to have a new kernel service.


>
>using WQ_UNBOUND (following iser-target) and verify if observed
>bottleneck is due to internal !(WQ_UNBOUND) usage in qla_target.c.

QT> we tried Unbound as one of the low hang fruits. However, Unbound ha=
s
negative affect when it comes to scaling.


>
>Out of curiosity, what level of performance improvement does this
>patch (as is) actually provide..?

QT> By itself =B3without" this patch series would be minimal.  With the
patch series, it allows us to consistently maintain an additional (appr=
ox)
+50~70k IOPS @4k read. Otherwise, the load is not sustainable or has a
chance to increase.

The test I use is 2ports Initiator vs 2 ports target, 2 * Qlogic 16G du=
al
port, TCM ramdisk.=20

>
>Thank you,
>
>--nab

>
>--
>To unsubscribe from this list: send the line "unsubscribe target-devel=
" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
