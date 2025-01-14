Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113D81586C8
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jan 2025 15:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736867730; cv=none; b=VyEGla5dQ5hHE2cd72CQecP8ut0D3wLKXeRSUTtbidjvsrlIO3zyBrSpBSsXgDml8hb47341TceB+pTL0xwmv+awDMTQX6PmxlCT2TVrAa4THZfj9Zut8hXym8FclN9k+u+veaq68+RixeaAB1nWeXYMhyy/FjmDTO5h2/Kqx0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736867730; c=relaxed/simple;
	bh=wfXyhtiQPnU2HE0W4lXp0FNyqSd4JhxvaFWQFFh7dcw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aXnDBV7pjYthGOeZCD+ZDQsPveGL58/hrwvQFGhSfA2XjSt9jI7oIJdiQExG9Xeb9/rYmR4YHonli5RM+HCoCWGOIX/aoW1Qz4/0mgi9MqfZ4QeggE0NCgFNF8QWFhNt86y0cVBTpjbyX/slBJ+nsDzbeE70BJSK20qAFY6rT/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QekxIUbO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QekxIUbO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736867726;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5mNuXciAb5PuQi+i36llnf9CVbQqWe+kNA6jURmPnkg=;
	b=QekxIUbOWIrOQZVM2htgUlqnd64y8Zu7yfZ9ItrSn/EzjiwPjEIO8EetxQXEHGX0owSlxR
	45i5/++MDHF7Kw1BG1kOEMRUi6gURNN2oUVt5ZZuc006FXBaes8eCbt5a50RPc10KDBjlh
	k5bOP77KFD6kUBiwVNyfU1jJl0j8gUU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-404-0yitujSRPBuRvZvJJLvPQQ-1; Tue,
 14 Jan 2025 10:15:20 -0500
X-MC-Unique: 0yitujSRPBuRvZvJJLvPQQ-1
X-Mimecast-MFC-AGG-ID: 0yitujSRPBuRvZvJJLvPQQ
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6372C195607C;
	Tue, 14 Jan 2025 15:15:16 +0000 (UTC)
Received: from [10.22.80.21] (unknown [10.22.80.21])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 77B3B30001BE;
	Tue, 14 Jan 2025 15:15:13 +0000 (UTC)
Message-ID: <dfa5c473-ef65-4065-b64a-6bcd213a26bc@redhat.com>
Date: Tue, 14 Jan 2025 10:15:12 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 07/15] scsi: fnic: Add and integrate support for FDMI
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Karan Tilak Kumar <kartilak@cisco.com>, sebaddel@cisco.com,
 arulponn@cisco.com, djhawar@cisco.com, gcboffa@cisco.com, mkai2@cisco.com,
 satishkh@cisco.com, aeasi@cisco.com, jejb@linux.ibm.com,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>
References: <20241212020312.4786-1-kartilak@cisco.com>
 <20241212020312.4786-8-kartilak@cisco.com>
 <4141c9ab-c640-4765-a23c-c2f64df687cb@stanley.mountain>
 <d18ed046-0d16-49d6-b666-8ef8ee20f6d2@redhat.com>
 <b3c29afc-c49b-42af-9733-7cf2b934cd90@stanley.mountain>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <b3c29afc-c49b-42af-9733-7cf2b934cd90@stanley.mountain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Hi Dan.

I absolutely agree with all of your comments and I appreciate your review.
I agree that all of the issues you've pointed out, with the the exception of
one, need to be addressed. The issues pointed out - especially the string
manipulation issues - can turn into CVEs. We don't want to be checking bugs
like this into Linux. Certainly, nothing should be merged that does not
pass the static checker, et al, automated tools we have.

My comment here was only to say that I don't think it's reasonable to
ask Karan to break this change into a series of 100 small, reviewable changes.

To explain: the fnic driver is Cisco's driver. Cisco has always taken responsibility
for this driver and Karan is one of the many Cisco Maintainers. What's happening is,
after a long period of time where the code has been somewhat neglected, Cisco has
decided to do a major update of their upstream driver. These changes
are really more like a new driver, with some major new features, than a
series of bug fixes or updates. This is happening because - at the insistence
of some of the Distros, like Red Hat - Cisco is being told they need to bring
their upstream drivers in line with their out-of-box drivers.

Karan can confirm if this is the case. My question for Karan is: are there any more
major driver changes coming for fnic, or is this the majority of it?

If this were simply a new feature or a series of bug fixes I agree the changes
need to be organized into a series of small, reviewable patches. However,
under the circumstances, I am willing to hold my nose and say: just get your driver
updated and into order, and then we will hold the Maintainers (not Martin) accountable.

So I guess I am recommending an exception to the rule, just this once, in regard to breaking the
overall change into a smaller and smaller patch series. I would prefer, instead, that any and all
changes needed to address further review comments be presented as a small series of patches, broken
down into reviewable chunks, on top of the exiting patch series. It can be decided later if these
patches can or should be squashed into the respective 17 commits.

Anyways, those are my thoughts.

Thanks again for your help with this review. I agree Karan needs help and support,
and I will try to be more public about they ways I am doing that - which have been
mostly in the back-ground.

/John

On 1/14/25 04:59, Dan Carpenter wrote:
> On Mon, Jan 13, 2025 at 12:35:03PM -0500, John Meneghini wrote:
>> Just a note to say that these patches are important to Red Hat and we
>> are actively engaged in back porting and testing these patches in to
>> RHEL-9 and RHEL-10.
>>
>> I think these issues that Dan has pointed out are all issues which
>> can be addressed in a follow up patch.
> 
> I mean we already merged this.  I only got involved because of static
> checker issues in linux-next.
> 
> What I'm complaining about is not so much any specific issue but just
> that the process was not followed.  Normally this patch would not
> be merged.  If anyone sent a patch like this to drivers/staging it
> would have triggered Greg's patch-bot automated response:
> 
> - Your patch did many different things all at once, making it difficult
>    to review.  All Linux kernel patches need to only do one thing at a
>    time.  If you need to do multiple things (such as clean up all coding
>    style issues in a file/driver), do it in a sequence of patches, each
>    one doing only one thing.  This will make it easier to review the
>    patches to ensure that they are correct, and to help alleviate any
>    merge issues that larger patches can cause.
> 
> This rule is the same in every subsystem.  No one wants to merge a patch
> like this.  But what happened is the patch sat on the list and only
> Hannes and Martin were doing any review.  Karan was left doing all the
> work with no help or guidance.  Eventually Martin has to give up right?
> The patchset isn't up to normal standards but it's basically okay and
> Martin can't do every single thing by himself and eventually it's pretty
> clear no one else is coming to help.  It is what it is etc.
> 
> Please understand this in the gentlest way.  Next time if something is
> important then assign an engineer to help out.  It would have taken a day
> to prepare this patchset for merging.  You had seven months.  It's not
> fair to show up five days before the merge window asking for special
> exemptions from the review process.  Maintainers and reviewers are
> already overworked, they shouldn't have to work around your deadlines.
> 
>  From what I've seen Karan is absolutely doing a good job addressing the
> problems I reported so it's fine.  But normally this is not how it works.
> 
> regards,
> dan carpenter
> 

