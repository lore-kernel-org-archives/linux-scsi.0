From: cang@codeaurora.org
Subject: Re: [PATCH v1] scsi: ufs: add 2 lane support
Date: Mon, 08 Oct 2018 16:48:22 +0800
Message-ID: <dfebd55dc6df88916876388dcdad3aa4@codeaurora.org>
References: <20180302082346.8188-1-cang@codeaurora.org>
 <CAE=gft6f9a2RoAvXR4+2tKZE-3chobb_HfbMDErfU1Q=_8uYwA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAE=gft6f9a2RoAvXR4+2tKZE-3chobb_HfbMDErfU1Q=_8uYwA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Evan Green <evgreen@chromium.org>
Cc: subhashj@codeaurora.org, asutoshd@codeaurora.org, vivek.gautam@codeaurora.org, Rajendra Nayak <rnayak@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, venkatg@codeaurora.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Evan,

On 2018-10-04 02:34, Evan Green wrote:
> Hi,
> 
> On Wed, Oct 3, 2018 at 11:19 AM Can Guo <cang@codeaurora.org> wrote:
>> 
>> From: Venkat Gopalakrishnan <venkatg@codeaurora.org>
>> 
>> Qcom ufs controller v3.1.0 supports 2 lanes, add support
>> to configure 2 lanes during phy initialization.
> 
> I'm reviving this old chestnut, sorry I missed it initially. This
> description is a little terse, and I'm actually confused about it. The
> description makes it sounds like this patch is adding support for
> 2-lane UFS controllers, but the patch itself appears to only make the
> UFS controller tolerant of a missing lane (or more specifically, a
> missing lane clock). Can you describe a little more about what's going
> on here, and perhaps fix the description?
> 
> I notice that the global clock controller has clocks for TX symbol 0,
> and RX symbol 1, but seems to be missing GCC_UFS_PHY_TX_SYMBOL_1_CLK.
> Was that an oversight, or is it really not there?
> 

You are right. The name and commit message are not representing itself
correctly as most of the original commit has been upstreamed already.
I uploaded a new patch to address it.

As per Qcom's design Tx Lane1 clock derives from Tx Lane0. So only
one Tx Lane0 clock would make 2 Tx lanes work.

>> 
>> Signed-off-by: Venkat Gopalakrishnan <venkatg@codeaurora.org>
>> Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
>> Signed-off-by: Can Guo <cang@codeaurora.org>
>> ---
>>  drivers/scsi/ufs/ufs-qcom.c | 20 +++++++++-----------
>>  1 file changed, 9 insertions(+), 11 deletions(-)
>> 
>> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
>> index 2b38db2..51889ad 100644
>> --- a/drivers/scsi/ufs/ufs-qcom.c
>> +++ b/drivers/scsi/ufs/ufs-qcom.c
>> @@ -113,10 +113,10 @@ static void ufs_qcom_disable_lane_clks(struct 
>> ufs_qcom_host *host)
>>         if (!host->is_lane_clks_enabled)
>>                 return;
>> 
>> -       if (host->hba->lanes_per_direction > 1)
>> +       if (host->tx_l1_sync_clk)
>>                 clk_disable_unprepare(host->tx_l1_sync_clk);
>>         clk_disable_unprepare(host->tx_l0_sync_clk);
>> -       if (host->hba->lanes_per_direction > 1)
>> +       if (host->rx_l1_sync_clk)
>>                 clk_disable_unprepare(host->rx_l1_sync_clk);
>>         clk_disable_unprepare(host->rx_l0_sync_clk);
>> 
>> @@ -147,18 +147,15 @@ static int ufs_qcom_enable_lane_clks(struct 
>> ufs_qcom_host *host)
>>                 if (err)
>>                         goto disable_tx_l0;
>> 
>> -               err = ufs_qcom_host_clk_enable(dev, 
>> "tx_lane1_sync_clk",
>> -                       host->tx_l1_sync_clk);
>> -               if (err)
>> -                       goto disable_rx_l1;
>> +               /* The tx lane1 clk could be muxed, hence keep this 
>> optional */
> 
> I'm confused by this comment. What do you mean the clock could be 
> muxed?
> 
>> +               if (host->tx_l1_sync_clk)
>> +                       ufs_qcom_host_clk_enable(dev, 
>> "tx_lane1_sync_clk",
>> +                                                
>> host->tx_l1_sync_clk);
>>         }
>> 
>>         host->is_lane_clks_enabled = true;
>>         goto out;
>> 
>> -disable_rx_l1:
>> -       if (host->hba->lanes_per_direction > 1)
>> -               clk_disable_unprepare(host->rx_l1_sync_clk);
>>  disable_tx_l0:
>>         clk_disable_unprepare(host->tx_l0_sync_clk);
>>  disable_rx_l0:
>> @@ -189,8 +186,9 @@ static int ufs_qcom_init_lane_clks(struct 
>> ufs_qcom_host *host)
>>                 if (err)
>>                         goto out;
>> 
>> -               err = ufs_qcom_host_clk_get(dev, "tx_lane1_sync_clk",
>> -                       &host->tx_l1_sync_clk);
>> +               /* The tx lane1 clk could be muxed, hence keep this 
>> optional */
>> +               ufs_qcom_host_clk_get(dev, "tx_lane1_sync_clk",
>> +                                       &host->tx_l1_sync_clk);
>>         }
>>  out:
>>         return err;
