Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BED7085;
	Mon,  4 Dec 2023 19:15:25 -0800 (PST)
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-5bdb0be3591so3007216a12.2;
        Mon, 04 Dec 2023 19:15:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701746125; x=1702350925;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a8T1GuM6HKEiuHh3tNrm/tVV4M4n9vSsl27RmV9NUNo=;
        b=uuxIyDl+ORWFblYw9htyGWdHi+tSBKgR1J+Amz+Nod15rWmSIYiLdRzRhUwJ6FkqUT
         3LTVAxcPu5Uyq9tJC2fNYsQWDPyFAk7gl5oJKBouLoxy6iSp6TVA1dOzVYj13YOQEi0w
         aEoCxYsTcJVvwUHLktBprd2Mm0R5SUoKfaQk4B7jSxDB+OILC6z8yNmWKHjj3yW5UkwS
         zfOjICbpWd5GOEMo8wgdPMQu69gke0OJa0O+WnxRy9H/UzHMPV72ZDZ3UeB3ggT1cKSh
         hIroAkaLuxZiBifVKOzXMGHJ3EM/ICNdmbMYv4H7FnM3SC77C80AgVIWDVAPBSarlVu7
         6kAw==
X-Gm-Message-State: AOJu0YwgE4frzySOWu04cC9Y4Fvb1zGkB5HS3ZHBcEywSi8Cf2QzQGPI
	LxAh67xUg/Rvgq940GvukeA=
X-Google-Smtp-Source: AGHT+IGcrTvR89vMTz2d+3PEPxrNySoDH+6OFOJt5/lkiilLXly+Js6dQfGHHqEQ88rNw3ympUh4bw==
X-Received: by 2002:a05:6a20:7f83:b0:18f:97c:8a30 with SMTP id d3-20020a056a207f8300b0018f097c8a30mr6043130pzj.91.1701746124760;
        Mon, 04 Dec 2023 19:15:24 -0800 (PST)
Received: from [172.20.2.177] ([173.197.90.226])
        by smtp.gmail.com with ESMTPSA id 20-20020a17090a005400b0028652f98978sm7675173pjb.8.2023.12.04.19.15.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Dec 2023 19:15:24 -0800 (PST)
Message-ID: <3a878745-a667-47ad-ac87-867a9bb8bd34@acm.org>
Date: Mon, 4 Dec 2023 19:15:19 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/6] Disable fair tag sharing for UFS devices
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>
References: <20231130193139.880955-1-bvanassche@acm.org>
 <20231204075252.GA29579@lst.de>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20231204075252.GA29579@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/3/23 23:52, Christoph Hellwig wrote:
> On Thu, Nov 30, 2023 at 11:31:27AM -0800, Bart Van Assche wrote:
>> The fair tag sharing algorithm reduces performance for UFS devices
>> significantly. This is because UFS devices have multiple logical units, a
>> limited queue depth (32 for UFS 3.1 devices), because it happens often that
>> multiple logical units are accessed and also because it takes time to
>> give tags back after activity on a request queue has stopped. This patch series
>> restores UFS device performance to that of the legacy block layer by disabling
>> fair tag sharing for UFS devices.
> 
> I feel like a broken record:
> 
> fair tag sharing exists for a reason.  Opting out of it for a specific
> driver does not make any sense.  Either you can make a good argument
> why you don't want it at all, or for specific configurations you
> can clearly explain, or you make it work faster.  A "treat my driver
> special" flag is never acceptable.

Hi Christoph,

Feedback that helps improving a patch series is always welcome.

Here is how I see fair tag sharing:
* Users probably want to configure minimum and maximum bandwidth or IOPS
   values instead of an equal number of tags per request queue. I assume
   that the fair tag sharing algorithm assigns an equal number of tags to
   each request queue since the run-time cost of the latter algorithm is
   much lower than the run-time cost of the previous algorithms.
* Any algorithm that is more sophisticated than the current fair tag
   sharing algorithm would have a higher runtime cost. We don't want to
   increase the cost of command processing in the block layer core.

Hence my proposal to disable the fair tag sharing algorithm if it's not
needed. I don't see a good alternative to this approach.

Thanks,

Bart.
