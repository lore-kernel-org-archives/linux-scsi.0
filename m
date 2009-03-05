From: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Q: "- PDU header Digest" fetaure
Date: Thu, 05 Mar 2009 11:17:11 +0200
Message-ID: <49AF9897.1070500@panasas.com>
References: <49A52E04.4844.B205C8A@Ulrich.Windl.rkdvmks1.ngate.uni-regensburg.de> <49A5821B.6070506@cs.wisc.edu>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <grbounce-FC1hwAUAAAA0O9VQcsxVj1UPjHD9r3x_=glio-open-iscsi=m.gmane.org-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <49A5821B.6070506-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Post: <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://googlegroups.com/group/open-iscsi/subscribe>,
	<mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org


Hi Mike, list.

Mike Christie has pointed out of a serious problem for us which we need
the list help of.

It started with a question by Ulrich Windl of why data-digests are
not supported/recommended by open-iscsi installations and distros.

[iscsi data-digests is when the complete payload of an iscsi transaction
 initiator-target is signed by an HMAC(SHA1) both read/write]

Mike Christie wrote:
> Ulrich Windl wrote:
>>
>
> Data digests were working but when upstream did the scatterlist changes 
> to the kernel it broke data digests. We have not found the cause yet.
> 
> For Red Hat, they do not support them for different reasons depending on 
> the version and arch. For example in RHEL5, the big endien crypto digest 
> code is busted. It needs a fix from upstream, and I think in general 
> there is still some other bugs in the digest code.
> 
>> I see the performance impact, but is there another reason against implementing it? 
>> Can I safely activate it on the target, or will it cause problems?
>>
> 
> Another reason a lot of distros do not support it is because a common 
> problem we always hit is that users will write out some data, then start 
> modifying it again. But the kernel will normally not do do a sync write 
> when you do a write. So once the write() returns, the kernel is still 
> sending it through the caches, block, scsi, and iscsi layers. If you are 
> writing to the data while the it is working its way through the iscsi 
> layers, the iscsi layer could have done the digest calculation, then you 
> could modify it and now when the target checks it the digest check will 
> fail. And so this happens over and over and you get digest errors all 
> over the place and the iscsi layers fire their error handling and retry 
> and retry, and in the end they just say forget it and do not support 
> data digests.
> 

Mike if what you said in the last paragraph is true, about FS modifying the data
while the request is in-flight, then it does not explain your statement above
about, things getting worse around the scatterlist changes.

The way I see it there can be two fundamental problems:
1. The FS is permitted to (or sinfully) modifies pages of memory while a request to
   write these pages is already in-flight. fsdevel guys might want to comment on that?
   Mike have you observed these problems with a particular file system?
   I can anticipate such a problem arising in a memory-mapped IO, while a page-cache
   write-back is in progress. Is that so? is Linux not safe in this regard? If so
   how does DM & MD do there raid parity calculations? do they copy the data?

2. iSCSI releases the request too soon, before the all data was actually used up by the
   network stack, and is allowing the FS to continue modifying these pages.
   This is a serious problem which means that there can be crashes and data corruption even
   if data-digest are not used.
   Actually we did move not long ago from copy of network data to been completely copy-less
   could that be the point in time things stopped working?

3. Plain coding bug, but I could not find any.

I know in the passed that data-digests are a grate tool for finding bugs that otherwise can
go undetected, it happened to me several times in the passed. All of these cases reviled a flaw
in the code, do to rebasing, things changing, plain programmer bugs.

Mike, I'm running here a plain iscsi initiator-target setup and the regression tests, and it
runs. What setup and tests did you run to trigger these digest retries, I would like to
reproduce this here, and investigate.

Thanks for any help
Boaz
