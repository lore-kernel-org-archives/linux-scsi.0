From: Hannes Reinecke <hare@suse.de>
Subject: Re: [RFC] relaxed barrier semantics
Date: Fri, 06 Aug 2010 16:56:56 +0200
Message-ID: <4C5C22B8.9040109@suse.de>
References: <4C4FECFE.9040509@kernel.org> <20100728085048.GA8884@lst.de> <4C4FF136.5000205@kernel.org> <20100728090025.GA9252@lst.de> <4C4FF592.9090800@kernel.org> <20100728092859.GA11096@lst.de> <20100802173930.GP16630@think> <4C5AB89C.5080700@vlnb.net> <20100805133225.GF29846@think> <4C5B1583.6070706@vlnb.net> <20100805195048.GA19030@lst.de> <4C5B19A0.9070200@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4C5B19A0.9070200@vlnb.net>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Christoph Hellwig <hch@lst.de>, Chris Mason <chris.mason@oracle.com>, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, tytso@mit.edu, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

Vladislav Bolkhovitin wrote:
> Christoph Hellwig, on 08/05/2010 11:50 PM wrote:
>> On Thu, Aug 05, 2010 at 11:48:19PM +0400, Vladislav Bolkhovitin wrot=
e:
>>> So, I believe, Linux must use that possibility to get full storage
>>> performance and to finally simplify its storage stack.
>>
>> So instead of talking what about doing a prototype and show us what
>> improvement it gives?
>=20
> Sure, I'd love to. But, unfortunately, I can't clone myself, so I'm
> trying to help the best of what I could: my level of storage and SCSI
> expertise. This area is quite special, so I'm trying to explain some
> misunderstandings I see and illustrate my points by some possible wor=
k
> flows and interfaces.
>=20
I can't, neither.

But I can do bonnie runs in no time.
I have done some preliminary benchmarks by just enable ordered
queueing in sd.c and no other changes.
Bonnie says:

Writing intelligently: 115208 vs.  82739=20
Reading intelligently: 134133 vs. 129395

putc() performance suffers, though:
I get 52M vs 90M writing and 50M vs. 65M reading.
No idea why; shouldn't be that harmful here.

But in any case there is some speed improvement
to be had from using ordered tags.

Oh, and that was against an EVA 6400.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
