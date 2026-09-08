Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10E352620DE
	for <linux-scsi@vger.kernel.org>; Tue,  8 Sep 2026 01:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788831808; cv=none; b=gZWdF8ofm6JIBUYWpcTxv/a6a+8uZdfnBhHA5vTRTAj4RIuefAMq5AGrjHasY/vq+5mOdKKlwtqEylGsHBiG3OzXgyYFNjOVs0GdN8qaQtLhyJFQjtRi+qj33Pf0iinpzChfIWQKj27XWLyEN9wzLo3SJKD+zbiUDC8linyZtDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788831808; c=relaxed/simple;
	bh=ybIb1+KZ/CGuf7E0OMPzAuT5M/ln2Rig7u2dTV3h36M=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=tcaj+9PLMvFoac5zKf3i5Gv8SC2vs6tqZb4jeUOtnzZgnQwotlE4MQS95GbPM1NFUZacRsKNcBsxQhP8nPb7t7QE2LWjN0sbgLDPrq6UUu41Yf2M5EPdvZeihHT9jjV1AXrq8qaOZom86T3uxhCl0aN9khLGACwO9t5DwmPtgUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=StlpHxGe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="StlpHxGe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE4C31F00A3A;
	Tue,  8 Sep 2026 01:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788831806;
	bh=Ony3NMtMU+1IJQIOOJAqg7DCFbpa3la+vABNEabn0OQ=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=StlpHxGeWUbNqQyfH//pN2Q0OI4Osmft1P55v2yFFy8KjTKccCRaD5VnzuSuBNvPF
	 lOCE64pMS7U3JUTKCBIHWwp0ihzLM9cjk0oJIEhK/a2zA0+EZ+QeyrLwO7b7cbgfa+
	 jGKnClaH1IY52VpVlk7nOfkMikKWuwSB3MNOZ4G9iNI6ttPJ1wxzyHYP8AHEpGkcvb
	 g+TY3B7kCFWyHA/EtnkA0vzMgxnYLa0vh5WCC+kbgckLYIY99k3DBRaIVX39u3TyRB
	 v2wZxbj0h+szSIz0WhCJqTURPXsmB3FvJ6HzaRUUeEnsRZTuE9LtnK4uYbl4degDZd
	 O3mUNcf+EMCtQ==
Message-ID: <83984308-5c0e-4f26-b071-93784996e481@kernel.org>
Date: Tue, 8 Sep 2026 10:43:14 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 01/40] scsi: define all additional sense codes and
 their qualifiers
To: Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 James Bottomley <James.Bottomley@hansenpartnership.com>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-2-dlemoal@kernel.org>
 <20260907031437.87FC41F00A3A@smtp.kernel.org>
 <531b5431-dc8d-4708-a67d-0bfcac96e1ea@kernel.org>
 <b7d26272-f53c-4355-a5ca-b6d9fb321599@gmail.com>
 <835e4db9-5be7-4118-94ee-afc412e82a2e@kernel.org>
 <7b329106-d5e0-472f-a9fb-72f979310c51@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <7b329106-d5e0-472f-a9fb-72f979310c51@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/8/26 10:20, Bart Van Assche wrote:
> On 9/7/26 5:30 PM, Damien Le Moal wrote:
>> Sure, easy to do. But I have not seen any compilation errors. So their is
>> currently no clash, but indeed, this is at the mercy of any change in included
>> files. So better safe here and I will rename. Not sure what a good prefix is
>> though... Maybe SCSI_WARNING ? Or SCSI_SENSE_WARNING ? Any better suggestion?
> 
> As you know any enumeration label ends up in the global namespace so
> it's considered a good practice to make the names of all enumeration
> labels of the same enumeration type start with the same prefix. Would
> it be acceptable to make all labels in enum scsi_sense_code start with
> the SCSI_SENSE_ prefix? The labels in enum scsi_sense_key probably could
> also use a prefix? Constants with names like "NOT_READY" and "COMPLETED"
> might also be defined in other kernel headers. Would SSK_ (SCSI SENSE
> KEY) be a good prefix?

The sense keys have been defined as they are for years, and there are no issues
that I know of about that. So I am not going to touch that in this series.
For the sense codes and their combination with sense code qualifiers, I could
prefix everything with SSC_ but I do not really see the point given that most
definitions are very peculiar as they follow mostly the exact naming of the T10
list. I did that in purpose so that it is easier to code/debug while looking at
T10 specifications. I did shorten some names (e.g. LOGICAL UNIT -> LU) to try
to avoid excessively long names as these force very long code lines, which is
not nice. Adding an SSC_ prefix will go against that goal.

The 8-bits sense code definitions are already prefixed with ASC_. The sense
code + 0x00 qualifier definitions are not prefixed, so I renamed WARNING and
WRITE_ERROR with the SSC_ prefix added. That should be enough I think.
As mentioned in my initial email, a make allyesconfig is fine so there are no
name clashes that I can see, even without renaming anything.


-- 
Damien Le Moal
Western Digital Research
