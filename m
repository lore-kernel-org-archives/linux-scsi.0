From: Hannes Reinecke <hare@suse.de>
Subject: Re: dm-multipath test scripts
Date: Sat, 20 Feb 2016 10:42:16 +0100
Message-ID: <56C834F8.8050604@suse.de>
References: <20151007053923.GA10749@xzibit.linux.bs1.fc.nec.co.jp>
 <20160218171745.GA15071@redhat.com> <56C662F1.8070407@ce.jp.nec.com>
 <56C6D45A.6060407@ce.jp.nec.com> <20160219194216.GB21133@redhat.com>
 <20160220061247.GA23333@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42579 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1427185AbcBTJmT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 Feb 2016 04:42:19 -0500
In-Reply-To: <20160220061247.GA23333@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, Junichi Nomura <j-nomura@ce.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>

On 02/20/2016 07:12 AM, Mike Snitzer wrote:
> On Fri, Feb 19 2016 at  2:42pm -0500,
> Mike Snitzer <snitzer@redhat.com> wrote:
>
>> On Fri, Feb 19 2016 at  3:37am -0500,
>> Junichi Nomura <j-nomura@ce.jp.nec.com> wrote:
>>
>>> On 02/19/16 09:33, Nomura Junichi wrote:
>>>> On 02/19/16 02:17, Mike Snitzer wrote:
>>>>> What is the last kernel version that your scripts have worked on?
>>>>
>>>> v4.4 worked fine. I'll check with v4.5-rc4 when I get a machine.
>>>
>>> v4.5-rc4 works fine, too.
>>
>> Have you been running with blk-mq?
>> Either by setting CONFIG_DM_MQ_DEFAULT or:
>> echo Y > /sys/module/dm_mod/parameters/use_blk_mq
>>
>> I'm seeing test_02_sdev_delete fail with blk-mq enabled.
>
> I only see failure if I stack dm-mq ontop of old non-mq scsi devices =
with:
>
> echo N > /sys/module/scsi_mod/parameters/use_blk_mq
> echo Y > /sys/module/dm_mod/parameters/use_blk_mq
>
> If I use scsi-mq for the underlying devices all works fine (been test=
ing
> the latest dm-4.6 branch though, I'll go back and try stock 4.5-rc4 j=
ust
> to double check).
>
> But this makes me think the novelty of having dm-mq support stacking =
on
> non-blk-mq devices was misplaced.  It is a senseless config.  I'll
> probably remove support for such stacking soon (next week).

Hmm. I must admit I really, really don't like these 'once-and-for-all'
parameter.

ATM the only SCSI driver to support SCSI-mq properly are lpfc, virtio,=20
and fnic. None of the other driver have been modified, and I suspect th=
e=20
performance might be less than stellar.

So there will be configurations where one might want to run scsi-mq=20
alongside non-mq HBAs.

I would really love to see to make that more granular so that these=20
configurations can run efficiently.
I know Christoph is violently against it, but I don't really see any=20
solution presenting itself at the moment.

Maybe a good topic for LSF ...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
