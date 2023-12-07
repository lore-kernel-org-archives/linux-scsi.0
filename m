Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A56E8171A;
	Thu,  7 Dec 2023 15:40:33 -0800 (PST)
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-5bcfc508d14so1282142a12.3;
        Thu, 07 Dec 2023 15:40:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701992433; x=1702597233;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zKn1uN52FS2vEnu87exFjbGE3L6ww6nhW6mEF9xJpdY=;
        b=j1W5HQ1c80Pxc9Th+TizmO5bggVGR0pT75QDA0ojDdFM60+wt0+nHUHC3SpO58zTKY
         ZVYU2duGFJRE+glHbdKBvBnnCEAOc9Bg07h4naVF1IDol0Li+DU1Ylzkakl3xEdgg8xG
         nKsiugV8xXmdGV5JvQnEm0SQMLbOzdPtabUZr7NW+LKMVbt1yGbJSm8TxOLL6ZlAixr1
         xb7fRLXYL723NECXyARPgWgKYCxELZhMiOZWA5G7eSwT9Bg/jY7ejpN+Nu9jNzg4U0mh
         P0QWGxgACm78yf/o9e+w/v91FWls6/BgpfASkkYVkadfPJcE3CFSsagVuh1vUfoBbJH/
         waSg==
X-Gm-Message-State: AOJu0YzDottJN6cWIarTD1WENCMhVvqHBJRwBLCJtnc//LSwnAmLVr20
	etiVbpq5jwcUB67iiHZGwaw=
X-Google-Smtp-Source: AGHT+IGpBzzBNpZQ7aLw12Lr3CLhxhN6qPoBqHO53fH5/5G3Jl/lE2mmAKCb7d+3+G+uU5xrduerRg==
X-Received: by 2002:a05:6a20:a424:b0:18f:97c:977b with SMTP id z36-20020a056a20a42400b0018f097c977bmr2484338pzk.99.1701992432738;
        Thu, 07 Dec 2023 15:40:32 -0800 (PST)
Received: from [172.22.37.189] (076-081-102-005.biz.spectrum.com. [76.81.102.5])
        by smtp.gmail.com with ESMTPSA id i4-20020a62c104000000b006ceba4953f6sm360063pfg.8.2023.12.07.15.40.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Dec 2023 15:40:32 -0800 (PST)
Message-ID: <1e71a6bf-ac2f-41bc-8931-8b4fb7371118@acm.org>
Date: Thu, 7 Dec 2023 13:40:29 -1000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 05/17] fs: Restore kiocb.ki_hint
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 Daejun Park <daejun7.park@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>
References: <20231130013322.175290-1-bvanassche@acm.org>
 <20231130013322.175290-6-bvanassche@acm.org> <20231207174633.GE31184@lst.de>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20231207174633.GE31184@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/7/23 07:46, Christoph Hellwig wrote:
> On Wed, Nov 29, 2023 at 05:33:10PM -0800, Bart Van Assche wrote:
>> Restore support for passing file and/or inode write hints to the code
>> that processes struct kiocb. This patch reverts commit 41d36a9f3e53
>> ("fs: remove kiocb.ki_hint").
> 
> Same comment as for the previous one.

If kiocb.ki_hint is not restored, the kiocb users will have to use the
kiocb ki_filp member to obtain the write hint information. In other
words, iocb->ki_hint will have to be changed into
file_inode(iocb->ki_filp)->i_write_hint. Is that what you want me to do?

Thanks,

Bart.


