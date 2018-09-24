From: Sayali Lokhande <sayalil@codeaurora.org>
Subject: Re: [PATCH V14 1/2] scsi: ufs: set the device reference clock setting
Date: Mon, 24 Sep 2018 14:17:54 +0530
Message-ID: <0761c2c2-4366-0a20-6789-10c4c9498908@codeaurora.org>
References: <1537770516-28410-1-git-send-email-sayalil@codeaurora.org>
 <1537770516-28410-2-git-send-email-sayalil@codeaurora.org>
 <SN6PR04MB49250F1D665127DBA82137A3FC170@SN6PR04MB4925.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <SN6PR04MB49250F1D665127DBA82137A3FC170@SN6PR04MB4925.namprd04.prod.outlook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Avri Altman <Avri.Altman@wdc.com>, "subhashj@codeaurora.org" <subhashj@codeaurora.org>, "cang@codeaurora.org" <cang@codeaurora.org>, "vivek.gautam@codeaurora.org" <vivek.gautam@codeaurora.org>, "rnayak@codeaurora.org" <rnayak@codeaurora.org>, "vinholikatti@gmail.com" <vinholikatti@gmail.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>, "evgreen@chromium.org" <evgreen@chromium.org>, "riteshh@codeaurora.org" <riteshh@codeaurora.org>
Cc: "stummala@codeaurora.org" <stummala@codeaurora.org>, "adrian.hunter@intel.com" <adrian.hunter@intel.com>, "jlbec@evilplan.org" <jlbec@evilplan.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


On 9/24/2018 1:28 PM, Avri Altman wrote:
>> +static struct ufs_ref_clk ufs_ref_clk_freqs[] = {
>> +       {19200000, REF_CLK_FREQ_19_2_MHZ},
>> +       {26000000, REF_CLK_FREQ_26_MHZ},
>> +       {38400000, REF_CLK_FREQ_38_4_MHZ},
>> +       {52000000, REF_CLK_FREQ_52_MHZ},
>> +       {0, REF_CLK_FREQ_INVAL},
>> +};
>> +
>> +static inline enum ufs_ref_clk_freq
>> +ufs_get_bref_clk_from_hz(u32 freq)
>> +{
>> +       int i = 0;
>> +
>> +       while (ufs_ref_clk_freqs[i].freq_hz != freq) {
>> +               if (!ufs_ref_clk_freqs[i].freq_hz)
>> +                       return REF_CLK_FREQ_INVAL;
> Is the if clause really needed?
> you will return REF_CLK_FREQ_INVAL anyway
Yes. the if condition makes sure to return REF_CLK_FREQ_INVAL if freq is 
not what we expect.
>
>> +               i++;
> You might overrun here if freq is not what you've expected
Above if condition "if (!ufs_ref_clk_freqs[i].freq_hz)" prevents such 
overrun
as we will reach end of ufs_ref_clk_freqs[] (i.e upto  0, 
REF_CLK_FREQ_INVAL) when there is no match and thus we will return 
REF_CLK_FREQ_INVAL.
>> +       }
>> +
>> +       return ufs_ref_clk_freqs[i].val;
>> +}
