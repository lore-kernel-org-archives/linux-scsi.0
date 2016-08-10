From: David Milburn <dmilburn@redhat.com>
Subject: Re: Regarding AHCI_MAX_SG and (ATA_HORKAGE_MAX_SEC_1024)
Date: Wed, 10 Aug 2016 14:38:08 -0500
Message-ID: <57AB82A0.5080104@redhat.com>
References: <CAGnHSEnsfmO8ydLZGBmEXgRCYTZfy+sR3knCWfBhCz6_vLZMEw@mail.gmail.com> <20160810032613.GA25053@mtj.duckdns.org> <CAGnHSEkp8EyCU+roKgwzVo2HcpQEGdrLv65h3Z+uD=4YTUn9qQ@mail.gmail.com> <20160810151447.GI25053@mtj.duckdns.org> <57AB4B43.2010705@redhat.com> <CAGnHSEn6D3MqF4sMUhd__fNP59a6ff_Em-5eDMFA-eOZLpswVQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGnHSEn6D3MqF4sMUhd__fNP59a6ff_Em-5eDMFA-eOZLpswVQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tom Yan <tom.ty89@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 08/10/2016 12:19 PM, Tom Yan wrote:
> On 10 August 2016 at 15:41, David Milburn <dmilburn@redhat.com> wrote:
>> Hi,
>>
>> The 168 makes AHCI_CMD_TBL_SZ equal to 2816
>>
>> AHCI_CMD_TBL_SZ = AHCI_CMD_TBL_HDR_SZ + (AHCI_MAX_SG * 16)
>> AHCI_CMD_TBL_SZ = 128 + (168 * 16)
>>
>> I think if you add in AHCI_CMD_SLOT_SZ (1024) and AHCI_RX_FIS_SZ (256)
>> the DMA is 4K aligned, I think that is where the 168 came from.
>
> Looks like the right guess. Though AHCI_PORT_PRIV_DMA_SZ is not:
>
> AHCI_CMD_SLOT_SZ (1024) + AHCI_CMD_TBL_SZ (2816) + AHCI_RX_FIS_SZ (256) = 4096
>
> but:
>
> AHCI_CMD_SLOT_SZ (1024) + AHCI_CMD_TBL_AR_SZ (2816 * 32 = 90112) +
> AHCI_RX_FIS_SZ (256) = 91392
>
> and AHCI_PORT_PRIV_FBS_DMA_SZ is:
>
> AHCI_CMD_SLOT_SZ (1024) + AHCI_CMD_TBL_AR_SZ (2816 * 32 = 90112) +
> AHCI_RX_FIS_SZ * 16 (4096) = 95232
>

Yes, but in both cases mem_dma gets adjusted for AHCI_CMD_SLOT_SZ (1024)
and rx_fis_sz (256 or 4096 in fbs case).

Thanks,
David
