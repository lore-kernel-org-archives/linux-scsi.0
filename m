Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D0155E60;
	Mon,  8 Jan 2024 19:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-5ce07cf1e5dso719611a12.2;
        Mon, 08 Jan 2024 11:30:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704742213; x=1705347013;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mPgSYdyg0vJbc0oY7GHDCNU+QLqplixDcaSjAanyb7k=;
        b=WZRI4708CeZ7zM7TqvZ4zn2hdByPTljoRERTr6Gc/JJfYHDpK/+ZgxDd/DhuxV+lis
         fEAeFOvHWyDb1STwGz2X4hR6rm7pytX8wcmEdUwrmRn1qs0DtXTqk+nNXz1ydIP50NIC
         1/lJKph/9LeYyaVG8+nL8gPbLRYdZ/FNpJcLy/B/Ihy73tzihjT9aOv0T7pLFU2wYN7n
         WSbq0Ms8q+4f8pjIYyuI6dHEdKfqFnBvXUIiXyZNOC4zVO63mZo+AUl66LK2d5Z77ZzB
         9BjTuIFubR6ZLpgufugu9TO3kv8WjJ6BXe0DTzgUtz/yf1khRpC+tjxn1XXi9jJQrhXV
         m2xg==
X-Gm-Message-State: AOJu0YzOHjU87WXPUbGEkNIQne7uNhRJV0w7KWfqSr1Tf9htXC9dL4b1
	d1/aR7mFnXr8QSGrcuSOPEY=
X-Google-Smtp-Source: AGHT+IF9dFWPN1tQY/0ojsSkLwZINpIlgjvVcvpzzmGaFhbrOj0bf8qRtWX+L0MtV9ncMN2wK/MWEw==
X-Received: by 2002:a05:6a20:a115:b0:199:31af:9207 with SMTP id q21-20020a056a20a11500b0019931af9207mr1834279pzk.52.1704742213013;
        Mon, 08 Jan 2024 11:30:13 -0800 (PST)
Received: from ?IPV6:2620:0:1000:8411:fe53:b285:ad53:95e0? ([2620:0:1000:8411:fe53:b285:ad53:95e0])
        by smtp.gmail.com with ESMTPSA id s9-20020aa78d49000000b006d9b2d86bcasm233119pfe.46.2024.01.08.11.30.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jan 2024 11:30:12 -0800 (PST)
Message-ID: <9b46c48f-d7c4-4ed3-a644-fba90850eab8@acm.org>
Date: Mon, 8 Jan 2024 11:30:10 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Large block for I/O
Content-Language: en-US
To: Christoph Hellwig <hch@infradead.org>,
 Matthew Wilcox <willy@infradead.org>
Cc: Hannes Reinecke <hare@suse.de>, lsf-pc@lists.linuxfoundation.org,
 linux-mm@kvack.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
References: <7970ad75-ca6a-34b9-43ea-c6f67fe6eae6@iogearbox.net>
 <4343d07b-b1b2-d43b-c201-a48e89145e5c@iogearbox.net>
 <03ebbc5f-2ff5-4f3c-8c5b-544413c55257@suse.de>
 <5c356222-fe9e-41b0-b7fe-218fbcde4573@acm.org>
 <ZYUbB3brQ0K3rP97@casper.infradead.org> <ZYUgo0a51nCgjLNZ@infradead.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ZYUgo0a51nCgjLNZ@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/21/23 21:37, Christoph Hellwig wrote:
> On Fri, Dec 22, 2023 at 05:13:43AM +0000, Matthew Wilcox wrote:
>> It clearly solves a problem (and the one I think it's solving is the
>> size of the FTL map).  But I can't see why we should stop working on it,
>> just because not all drive manufacturers want to support it.
> 
> I don't think it is drive vendors.  It is is the SSD divisions which
> all pretty much love it (for certain use cases) vs the UFS/eMMC
> divisions which tends to often be fearful and less knowledgeable (to
> say it nicely) no matter what vendor you're talking to.

Hi Christoph,

If there is a significant number of 4 KiB writes in a workload (e.g.
filesystem metadata writes), and the logical block size is increased from
4 KiB to 16 KiB, this will increase write amplification no matter how the
SSD storage controller has been designed, isn't it? Is there perhaps
something that I'm misunderstanding?

Thanks,

Bart.


