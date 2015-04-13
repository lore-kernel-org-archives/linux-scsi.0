From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH -next v3] target/rd: Don't pass imcomplete scatterlist
 entries to sbc_dif_verify_*
Date: Sun, 12 Apr 2015 21:59:31 -0700
Message-ID: <1428901171.15567.1.camel@haakon3.risingtidesystems.com>
References: <1428725851-9275-1-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1428725851-9275-1-git-send-email-akinobu.mita@gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: target-devel@vger.kernel.org, Sagi Grimberg <sagig@dev.mellanox.co.il>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, 2015-04-11 at 13:17 +0900, Akinobu Mita wrote:
> The scatterlist for protection information which is passed to
> sbc_dif_verify_read() or sbc_dif_verify_write() requires that
> neighboring scatterlist entries are contiguous or chained so that they
> can be iterated by sg_next().
> 
> However, the protection information for RD-MCP backends could be located
> in the multiple scatterlist arrays when the ramdisk space is too large.
> So if the read/write request straddles this boundary, sbc_dif_verify_read()
> or sbc_dif_verify_write() can't iterate all scatterlist entries.
> 
> This problem can be fixed by chaining protection information scatterlist
> at creation time.  For the architectures which don't support sg chaining
> (i.e. !CONFIG_ARCH_HAS_SG_CHAIN), fix it by allocating temporary
> scatterlist if needed.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Nicholas Bellinger <nab@linux-iscsi.org>
> Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
> Cc: target-devel@vger.kernel.org
> Cc: linux-scsi@vger.kernel.org
> ---
> * v3
> - Fix it by chaining protection information scatterlist at creation time
>   if CONFIG_ARCH_HAS_SG_CHAIN is defined.
> 
>  drivers/target/target_core_rd.c | 67 +++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 64 insertions(+), 3 deletions(-)

Applied to target-pending/for-next.

Thanks for updating to use CONFIG_ARCH_HAS_SG_CHAIN for the common
case.  :)

--nab
