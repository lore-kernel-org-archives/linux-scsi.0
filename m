From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH 5/5] nvme: use __blk_mq_complete_request in timeout path
Date: Mon, 25 Jun 2018 21:51:07 +0300
Message-ID: <80d1be8f-859e-5feb-a53e-c8be9c3e0213@grimberg.me>
References: <1529500964-28429-1-git-send-email-jianchao.w.wang@oracle.com>
 <1529500964-28429-6-git-send-email-jianchao.w.wang@oracle.com>
 <20180620143956.GA20950@lst.de>
 <42583ee2-fe9d-39da-b82a-38a27b03fdb3@oracle.com>
 <1817441e-6810-ed40-a8fd-403742818aae@grimberg.me>
 <cc93effe-8e97-d4a8-851e-33208cf837a7@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cc93effe-8e97-d4a8-851e-33208cf837a7@oracle.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "jianchao.wang" <jianchao.w.wang@oracle.com>, Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, martin.petersen@oracle.com, keith.busch@intel.com, josef@toxicpanda.com, ulf.hansson@linaro.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


>> Given the amount of fixes (and fixes of fixes) we had in the timeout handler, maybe it'd be a good idea to step back and take a another look?
>>
>> Won't it be better to avoid disabling the device and return
>> BLK_EH_RESET_TIMER if we are not aborting in the timeout handler?
>>
> 
> Yes, that would be an ideal status for nvme-pci.
> But we have to depend on the timeout handler to handle the timed out request from nvme_reset_work.

Yes, so if the timeout handler is invoked from the reset, it should
simply set a proper failed status and return BLK_EH_DONE.
