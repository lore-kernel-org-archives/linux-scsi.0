From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [LSF/MM TOPIC] iSCSI MQ adoption via MCS discussion
Date: Tue, 13 Jan 2015 20:16:28 -0800
Message-ID: <54B5ED9C.4080900@vlnb.net>
References: <54AD5DDD.2090808@dev.mellanox.co.il> <54AD6563.4040603@suse.de> <54ADA777.6090801@cs.wisc.edu> <54AE36CE.8020509@acm.org> <54AE8A02.1030100@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <54AE8A02.1030100@dev.mellanox.co.il>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>, Bart Van Assche <bvanassche@acm.org>, open-iscsi@googlegroups.com, Hannes Reinecke <hare@suse.de>, lsf-pc@lists.linux-foundation.org
Cc: linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, Oren Duer <oren@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

Sagi Grimberg wrote on 01/08/2015 05:45 AM:
>> RFC 3720 namely requires that iSCSI numbering is
>> session-wide. This means maintaining a single counter for all MC/S
>> sessions. Such a counter would be a contention point. I'm afraid that
>> because of that counter performance on a multi-socket initiator system
>> with a scsi-mq implementation based on MC/S could be worse than with the
>> approach with multiple iSER targets. Hence my preference for an approach
>> based on multiple independent iSER connections instead of MC/S.
> 
> So this comment is spot on the pros/cons of the discussion (we might want to leave
> something for LSF ;)).
> MCS would not allow a completely lockless data-path due to command
> ordering. On the other hand implementing some kind of multiple sessions
> solution feels somewhat like a mis-fit (at least in my view).
> 
> One of my thoughts about how to overcome the contention on commands
> sequence numbering was to suggest some kind of negotiable "relaxed
> ordering" mode but of course I don't have anything figured out yet.

Linux SCSI/block stack neither uses, nor guarantees any commands order. Applications
requiring commands order enforce it by queue draining (i.e. wait until all previous
commands finished). Hence, MC/S enforced commands order is an overkill, which
additionally coming with some non-zero performance cost.

Don't do MC/S, do independent connections. You know the KISS principle. Memory overhead
to setup the extra iSCSI sessions should be negligible.

Vlad
