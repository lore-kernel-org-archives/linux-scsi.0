From: Boaz Harrosh <openosd@gmail.com>
Subject: Re: [PATCH v2 1/3] scsi_cmnd: Introduce scsi_transfer_length helper
Date: Sun, 27 Jul 2014 11:45:11 +0300
Message-ID: <53D4BC17.5050004@gmail.com>
References: <1402477799-24610-1-git-send-email-sagig@mellanox.com> <1402477799-24610-2-git-send-email-sagig@mellanox.com> <53A89B0F.4040300@cs.wisc.edu> <yq1r42fgjbp.fsf@sermon.lab.mkp.net> <53AA2334.8000109@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <53AA2334.8000109@vlnb.net>
Sender: target-devel-owner@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Sagi Grimberg <sagig@mellanox.com>, nab@linux-iscsi.org, roland@kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 06/25/2014 04:17 AM, Vladislav Bolkhovitin wrote:
> Martin K. Petersen, on 06/23/2014 06:58 PM wrote:
>>>>>>> "Mike" == Mike Christie <michaelc@cs.wisc.edu> writes:
>>>> + unsigned int xfer_len = blk_rq_bytes(scmd->request);
>>
>> Mike> Can you do bidi and dif/dix?
>>
>> Nope.
> 
> Correction: at the moment.
> 
> There is a proposal of READ GATHERED command, which is bidirectional and potentially 
> DIF/DIX.
> 

That's all very good. But current infrastructure can not support BIDI+DIFF.
Because you we'll need *two* diff vectors one for each side.

Now in fact at the block layer this is actually supported. Since BIDI is
two requests, and each can have its own DIFF bio. But on the scsi layer
this is not implemented.

So I'd say: *For now DIFF and BIDI are mutually exclusive.*

(You'll need someone to love these new commands a lot in order to
 enable it)

> Vlad
> 

Cheers
Boaz
