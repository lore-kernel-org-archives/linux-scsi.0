From: Mike Christie <mchristi@redhat.com>
Subject: Re: [PATCH] tcmu: Recalculate the tcmu_cmd size to save cmd area
 memories
Date: Tue, 2 May 2017 21:06:35 -0500
Message-ID: <59093B2B.7000802@redhat.com>
References: <1493711669-31508-1-git-send-email-lixiubo@cmss.chinamobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1493711669-31508-1-git-send-email-lixiubo@cmss.chinamobile.com>
Sender: target-devel-owner@vger.kernel.org
To: lixiubo@cmss.chinamobile.com, nab@linux-iscsi.org
Cc: agrover@redhat.com, namei.unix@gmail.com, sheng@yasker.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 05/02/2017 02:54 AM, lixiubo@cmss.chinamobile.com wrote:
> From: Xiubo Li <lixiubo@cmss.chinamobile.com>
> 
> For the "struct tcmu_cmd_entry" in cmd area, the minimum size
> will be sizeof(struct tcmu_cmd_entry) == 112 Bytes. And it could
> fill about (sizeof(struct rsp) - sizeof(struct req)) /
> sizeof(struct iovec) == 68 / 16 ~= 4 data regions(iov[4]) by
> default.
> 
> For most tcmu_cmds, the data block indexes allocated from the
> data area will be continuous. And for the continuous blocks they
> will be merged into the same region using only one iovec. For
> the current code, it will always allocates the same number of
> iovecs with blocks for each tcmu_cmd, and it will wastes much
> memories.
> 
> For example, when the block size is 4K and the DATA_OUT buffer
> size is 64K, and the regions needed is less than 5(on my
> environment is almost 99.7%). The current code will allocate
> about 16 iovecs, and there will be (16 - 4) * sizeof(struct
> iovec) = 192 Bytes cmd area memories wasted.
> 
> Here adds two helpers to calculate the base size and full size
> of the tcmu_cmd. And will recalculate them again when it make sure
> how many iovs is needed before insert it to cmd area.
> 
> Signed-off-by: Xiubo Li <lixiubo@cmss.chinamobile.com>

Looks ok to me. Thanks.

Acked-by: Mike Christie <mchristi@redhat.com>
