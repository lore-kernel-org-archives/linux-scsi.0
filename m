Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1145EEA8;
	Sun,  5 Jul 2026 01:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783213715; cv=none; b=h+4fexwKJ5B+rgQu9xvC2+bX8Wn6Qki/SifG+fPxgYBMGb3sEDRxKy3/lfJgTOVzZHXWQaREVL3YBDnb3Zg95miRoqY4Lx6AtCm+tTeH0vqnO1wimzo3MiNr3IwskZ12L3uwWGUHhvXsGdvvDYfXBoD4BszpRMv6VPgF6qLlze8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783213715; c=relaxed/simple;
	bh=LWPYUtwiP4qqjkXrhpOF9pbAI0/d/JQPAgjz5Zg4+/c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Iu5salbxFXpYmQLjxLSwpnAjod0E3fu1SzforbrGP7e/iWZzAvwjl2iBWveYDPGvV1RYwWulKqlbNHDr7dmCJfkzECcTTHPMnTbKMJ0uqIMZp1IHxvpH9mhp6U7cgvGx/EHmfzey7D0ffiSfcl7BngYlWWQbjz/dv7pFR3QMQ2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GWUvZ0nH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GWUvZ0nH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BFDC1F000E9;
	Sun,  5 Jul 2026 01:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783213714;
	bh=z+SfoSYxdY3v7Q5/o4PGT9QgDCjTYCP6PRxWCtNMWGg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=GWUvZ0nHpJBJGFDRKjvsp0aidweBIjf3UO2T1NS7B3GednFqM7RvBHCVzJmCRFUUv
	 w9dVoszCe7lGO8XIX+kCgFyM4qOIrq4i0fVcQaJmDrU58zFTH8dwdZs/evrCkRBEpV
	 ea02khLi6TYCMPoQdDYhJUoLN+vzYLLzqPxwiueBFURSGFx2nLTXAFnWKo3MvfGDoi
	 UA7zjSvHbV7/X+tONndAkRFwNf5c2M7g1ddqzewFHpXhcC969QCiU2ecxCWSWFNh/a
	 i6IczHuYitfsfd2JlVPpPH/n/Jb42CbCuTVEgrhAqF/7XeuayvksMDQiw6GoIs2kmw
	 EbesETmyw8/yQ==
Message-ID: <bcd2926f-66df-4ffb-b0f8-97323cee5d94@kernel.org>
Date: Sun, 5 Jul 2026 10:08:31 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: st: use kzalloc_array
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-scsi@vger.kernel.org, =?UTF-8?Q?Kai_M=C3=A4kisara?=
 <Kai.Makisara@kolumbus.fi>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 open list <linux-kernel@vger.kernel.org>,
 open "list:KERNEL" HARDENING "(not" covered by other
 "areas):Keyword:b__counted_by(_le|_be|_ptr)?b"
 <linux-hardening@vger.kernel.org>
References: <20260630012101.1461335-1-rosenp@gmail.com>
 <17d381fb-1f91-461c-8315-1508ad0c1efe@kernel.org>
 <CAKxU2N8Be1XxVznSrV1KGWOyivNEFJjojd2KRXLguLYZEB=gYw@mail.gmail.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <CAKxU2N8Be1XxVznSrV1KGWOyivNEFJjojd2KRXLguLYZEB=gYw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 7/4/26 04:06, Rosen Penev wrote:
> On Tue, Jun 30, 2026 at 12:28 AM Damien Le Moal <dlemoal@kernel.org> wrote:
>>
>> On 6/30/26 10:21, Rosen Penev wrote:
>>> Signed-off-by: Rosen Penev <rosenp@gmail.com>
>>
>> No commit message ? Please explain your reasonning, because I find this patch
>> incorrect. See below.
>>
>>> ---
>>>  drivers/scsi/st.c | 12 +++---------
>>>  drivers/scsi/st.h |  3 ++-
>>>  2 files changed, 5 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
>>> index f1c3c4946637..31ae189b18e7 100644
>>> --- a/drivers/scsi/st.c
>>> +++ b/drivers/scsi/st.c
>>> @@ -149,7 +149,7 @@ static struct st_dev_parm {
>>>     mode counts */
>>>  static const char *st_formats[] = {
>>>       "",  "r", "k", "s", "l", "t", "o", "u",
>>> -     "m", "v", "p", "x", "a", "y", "q", "z"};
>>> +     "m", "v", "p", "x", "a", "y", "q", "z"};
>>>
>>>  /* The default definitions have been moved to st_options.h */
>>>
>>> @@ -3973,21 +3973,15 @@ static struct st_buffer *new_tape_buffer(int max_sg)
>>>  {
>>>       struct st_buffer *tb;
>>>
>>> -     tb = kzalloc_obj(struct st_buffer);
>>> +     tb = kzalloc_flex(*tb, reserved_pages, max_sg);
>>>       if (!tb) {
>>>               printk(KERN_NOTICE "st: Can't allocate new tape buffer.\n");
>>>               return NULL;
>>>       }
>>> -     tb->frp_segs = 0;
>>>       tb->use_sg = max_sg;
>>> +     tb->frp_segs = 0;
>>>       tb->buffer_size = 0;
>>>
>>> -     tb->reserved_pages = kzalloc_objs(struct page *, max_sg);
>>
>> reserve_pages is in the middle of struct st_buffer so you cannot use a flex array.
> This patch moves it, no?

Do! Completely missed that. Looks good then, but please write a commit message.

-- 
Damien Le Moal
Western Digital Research
