Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C4A4A2E1E
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 15:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791819071; cv=none; b=skod742Er0K56d8u+cXhW1tA1jm9IKq9u6kPTlN0DBBXxmfStNXw6UefC4p3dtQ+dLFwiDwah1JCX3WwkLfTCXjVQ070BFP5XDcIG4cA/7UO3Eq4OUzzg+R3BeV57iWyZ1UBYAJpOJGj43UhEIvMoejnZmrd9sttyZRR9QXtIYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791819071; c=relaxed/simple;
	bh=e/cdy57VIaZurMFLjijbmwAumpYTJ/q11wkS2VDAPHs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K3E9SPDsEee49U06vSkSkYIUlKRq8RTRlPR379nPTg9fyF5raKD2oEff8kGgnYnGCunEkRjt+Cb6l6sJYtLmM9lrVuEJPmpb2ErMLetx4DnZTtUSRmHzGY3fXTzjynRGe7kFEd20YH7f23ICs2+c0BmgpSeCE0M30ABHyD8sWpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=4S3ihFbx; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="4S3ihFbx"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4j3Lz13vDqz1XM4Tn;
	Mon, 12 Oct 2026 15:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1791819066; x=1794411067; bh=3Z8Rdgm8ag+dRF21mr/1x5yp
	QU4a3oEOnUN+YJ1Gqxs=; b=4S3ihFbxqoQKh/VaBpzNKRnx3jj5WWnjibE5eW+/
	P8hBW/Et3XhwLu1Ox6sMOjMwK8DiRZCBC2cA8fvFagcXketfXpNCap4IRsu9rwb8
	EJ7eFLS7ssThIvDuIeNdWp8Z7tZKdX2S/ZQv2lM4qO8GPbXvzP5MUUnEBP+Gx6E6
	yN/8PeX6HFXlLQV8m2IMhgunwIQNseQHGIeyJtTuKkmclaTOJ2IwurNR48KAWxuS
	w/kGCqjvbnh4BIn67N4k4hjbsSkdLspnpNLHRw7GdeRRcue8/drgeHZb2fXmLC4n
	wIqV/1xqk35f3keIPGEN5WopoobH8umqaiMxPeH8+zzauQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id UvCrP1QlT-Fe; Mon, 12 Oct 2026 15:31:06 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4j3Lyx6Cvbz1XM4Tl;
	Mon, 12 Oct 2026 15:31:05 +0000 (UTC)
Message-ID: <89e3bb6c-4e8a-4480-a6d4-e7f6a2ddbef1@acm.org>
Date: Mon, 12 Oct 2026 08:31:01 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 7/8] scsi: scsi_debug: Improve lock context annotations
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, John Garry <john.garry@linux.dev>
References: <cover.1791499174.git.bvanassche@acm.org>
 <e2ddd0bc90e0b5eb0b7eb72c0013d7e2e10be8fe.1791499174.git.bvanassche@acm.org>
 <20261012122457.GB31394@lst.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261012122457.GB31394@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/12/26 5:24 AM, Christoph Hellwig wrote:
> On Thu, Oct 08, 2026 at 03:42:18PM -0700, Bart Van Assche wrote:
>>   static inline void
>>   sdeb_meta_read_lock(struct sdeb_store_info *sip)
>> +	__acquires_shared(&sip->macc_meta_lck)
>> +	__context_unsafe(/*conditional locking*/)
>>   {
>> -	if (sdebug_no_rwlock) {
>> -		if (sip)
>> -			__acquire(&sip->macc_meta_lck);
>> -		else
>> -			__acquire(&sdeb_fake_rw_lck);
>> -	} else {
>> +	if (!sdebug_no_rwlock) {
> 
> Why can't this be modelled using a __acquire variant?  And if you
> add __context_unsafe(/*conditional locking*/) please add a detailed
> comment why that is needed, otherwise no one is going to understand
> this in the future.

Hi Christoph,

I will change the comment into "can't be annotated with
__{acquire,release}(,_shared}() without triggering undefined behavior".

What Sashiko reported on a Google-internal server for an
earlier attempt to annotate this and similar functions with
__{acquire,release}(,_shared}() has been included below. I think that
Sashiko is right:
=======================================================================
 >  static inline void
 >  sdeb_meta_read_lock(struct sdeb_store_info *sip)
 > +	__acquires_shared(&sip->macc_meta_lck)
 >  {
 >  	if (sdebug_no_rwlock) {
 > -		if (sip)
 > -			__acquire(&sip->macc_meta_lck);
 > -		else
 > -			__acquire(&sdeb_fake_rw_lck);
 > +		__acquire_shared(&sip->macc_meta_lck);
 >  	} else {
 > -		if (sip)
 > +		if (sip) {
 >  			read_lock(&sip->macc_meta_lck);
 > -		else
 > +		} else {
 >  			read_lock(&sdeb_fake_rw_lck);
 > +			__release_shared(&sdeb_fake_rw_lck);
 > +			__acquire_shared(&sip->macc_meta_lck);
                                          ^^^^^^^^^^^^^^^^^^^
Can this regression trigger an undefined behavior splat when sip is NULL?
When the scsi_debug driver is used with the module parameter fake_rw=1,
devip2sip() returns NULL. In this else branch, sip is explicitly NULL,
so evaluating &sip->macc_meta_lck means taking the address of a member
from a NULL pointer.
When compiled with Context Analysis and UBSAN (-fsanitize=null or
-fsanitize=pointer-overflow), the inline function call evaluates the
argument before the call and will trigger a runtime splat. Without UBSAN,
it calculates an invalid offset from a NULL pointer.
=======================================================================

Bart.


