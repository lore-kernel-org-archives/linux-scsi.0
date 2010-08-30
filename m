From: Hannes Reinecke <hare@suse.de>
Subject: Re: [RFC] training mpath to discern between SCSI errors
Date: Mon, 30 Aug 2010 14:39:12 +0200
Message-ID: <4C7BA670.2060303@suse.de>
References: <20100825155918.GB8509@redhat.com> <4C7B984E.4070802@suse.de> <4C7B9F14.9080900@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4C7B9F14.9080900@mvista.com>
Sender: linux-ide-owner@vger.kernel.org
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Tejun Heo <tj@kernel.org>, michaelc@cs.wisc.edu, James.Bottomley@suse.de, tytso@mit.edu, linux-scsi@vger.kernel.org, jaxboe@fusionio.com, jack@suse.cz, linux-kernel@vger.kernel.org, swhiteho@redhat.com, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, konishi.ryusuke@lab.ntt.co.jp, linux-fsdevel@vger.kernel.org, vst@vlnb.net, rwheeler@redhat.com, Christoph Hellwig <hch@lst.de>, chris.mason@oracle.com, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

Sergei Shtylyov wrote:
> Hello.
>=20
> Hannes Reinecke wrote:
>=20
>> Actually, I think we have two separate issues here:
>> 1) The need of having more detailed I/O errors even in the fs layer.=
 This
>>    we've already discussed at the LSF, consensus here is to allow ot=
her
>>    errors than just 'EIO'.
>>    Instead of Mike's approach I would rather use existing error code=
s
>> here;
>>    this will make the transition somewhat easier.
>>    Initially I would propose to return 'ENOLINK' for a transport fai=
lure,
>>    'EIO' for a non-retryable failure on the target, and 'ENODEV' for=
 a
>>    retryable failure on the target.
>=20
>    Are you sure it's not vice versa: EIO for retryable and ENODEV for
> non-retryable failures. ENODEV looks more like permanent condition to=
 me.
>=20
Ok, can do.
And looking a the error numbers again, maybe we should be using 'EREMOT=
EIO'
for non-retryable failures.

So we would be ending with:

ENOLINK: transport failure
EIO: retryable remote failure
EREMOTEIO: non-retryable remote failure

Does that look okay?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
