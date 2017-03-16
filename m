From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: Re: [PATCHv2 3/5] target/user: Fix possible overwrite of t_data_sg's
 last iov[]
Date: Thu, 16 Mar 2017 13:23:19 -0500
Message-ID: <15fede93-943a-e344-5257-2f1400decfe5@linux.vnet.ibm.com>
References: <1488962743-17028-1-git-send-email-lixiubo@cmss.chinamobile.com>
 <1488962743-17028-4-git-send-email-lixiubo@cmss.chinamobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1488962743-17028-4-git-send-email-lixiubo@cmss.chinamobile.com>
Sender: target-devel-owner@vger.kernel.org
To: lixiubo@cmss.chinamobile.com, agrover@redhat.com, nab@linux-iscsi.org, mchristi@redhat.com
Cc: shli@kernel.org, sheng@yasker.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, namei.unix@gmail.com
List-Id: linux-scsi@vger.kernel.org



On 3/8/17 2:45 AM, lixiubo@cmss.chinamobile.com wrote:
> From: Xiubo Li <lixiubo@cmss.chinamobile.com>
>
> If there has BIDI data, its first iov[] will overwrite the last
> iov[] for se_cmd->t_data_sg.
>
> To fix this, we can just increase the iov pointer, but this may
> introuduce a new memory leakage bug: If the se_cmd->data_length
> and se_cmd->t_bidi_data_sg->length are all not aligned up to the
> DATA_BLOCK_SIZE, the actual length needed maybe larger than just
> sum of them.
>
> So, this could be avoided by rounding all the data lengthes up
> to DATA_BLOCK_SIZE.
>
> Signed-off-by: Xiubo Li <lixiubo@cmss.chinamobile.com>
> ---
>   drivers/target/target_core_user.c | 32 +++++++++++++++++++-------------
>   1 file changed, 19 insertions(+), 13 deletions(-)

I have seen this in my environment:
(gdb) print *((tcmulib_cmd->iovec)+0)
$7 = {iov_base = 0x3fff7c3d0000, iov_len = 8192}
(gdb) print *((tcmulib_cmd->iovec)+1)
$3 = {iov_base = 0x3fff7c3da000, iov_len = 4096}
(gdb) print *((tcmulib_cmd->iovec)+2)
$4 = {iov_base = 0x3fff7c3dc000, iov_len = 16384}
(gdb) print *((tcmulib_cmd->iovec)+3)
$5 = {iov_base = 0x3fff7c3f7000, iov_len = 12288}
(gdb) print *((tcmulib_cmd->iovec)+4)
$6 = {iov_base = 0x1306e853c0028, iov_len = 128}  <--- bad pointer and length

So this fix would be great!

Signed-off-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
