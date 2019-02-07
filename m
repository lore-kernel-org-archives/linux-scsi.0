From: Alim Akhtar <alim.akhtar@samsung.com>
Subject: Re: [PATCH v3 5/5] Revert
 "scsi: ufs: disable vccq if it's not needed by UFS device"
Date: Thu, 7 Feb 2019 14:20:39 +0530
Message-ID: <90f24b35-89b0-cea0-1ab3-13c2a419b138@samsung.com>
References: <e3c82a49-c601-effc-348f-f768656c659f@free.fr>
        <CGME20190204174549epcas4p4682667176f55101f69cc24cc455c9f3c@epcas4p4.samsung.com>
        <70618c25-83f0-b9db-51a3-c1d74b605a45@free.fr>
        <5f2a8378-1f22-6a52-356d-56d3b393ab1d@samsung.com>
        <05d2d193-4181-12ce-b4fb-4e8dec5aef27@free.fr>
        <7610c262-1451-9bb2-48a6-4daf6f534f6c@free.fr>
        <42c86292-22e9-4c5e-d64d-bc6107af45bf@free.fr>
        <740e6332-b54f-ab62-915a-0aec6be450d3@samsung.com>
        <2a59c11a-037f-c8c3-235a-9b21183a0801@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2a59c11a-037f-c8c3-235a-9b21183a0801@free.fr>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Gonzalez <marc.w.gonzalez@free.fr>, MSM <linux-arm-msm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Jeffrey Hugo <jhugo@codeaurora.org>, Bjorn Andersson <bjorn.andersson@linaro.org>, Andy Gross <andy.gross@linaro.org>, David Brown <david.brown@linaro.org>, Evan Green <evgreen@chromium.org>, Douglas Anderson <dianders@chromium.org>, Avri Altman <avri.altman@wdc.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, Subhash Jadavani <subhashj@codeaurora.org>, Bart Van Assche <bvanassche@acm.org>, SCSI <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

Hi Marc,

On 06/02/19 9:22 PM, Marc Gonzalez wrote:
> On 06/02/2019 16:27, Alim Akhtar wrote:
> 
>> On 06/02/19 8:29 PM, Marc Gonzalez wrote:
>>
>>> [    2.405734] regulator_disable: ENTER vdd_l26
>>> [    2.405958] regulator_disable: EXIT vdd_l26
>>> [    2.406032]   regulator_set_load: vdd_l26 = 0 uA
>>> [    3.930447] ufshcd-qcom 1da4000.ufshc: ufshcd_query_attr: opcode 0x04 for idn 13 failed, index 0, err = -11
>>> [    5.434358] ufshcd-qcom 1da4000.ufshc: ufshcd_query_attr: opcode 0x04 for idn 13 failed, index 0, err = -11
>>> [    6.938318] ufshcd-qcom 1da4000.ufshc: ufshcd_query_attr: opcode 0x04 for idn 13 failed, index 0, err = -11
>>> [    6.938414] ufshcd-qcom 1da4000.ufshc: ufshcd_query_attr_retry: query attribute, idn 13, failed with error -11 after 3 retires
>>> [    6.946959] ufshcd-qcom 1da4000.ufshc: ufshcd_disable_auto_bkops: failed to enable exception event -11
>>> [    6.958523] ufshcd-qcom 1da4000.ufshc: dme-peer-get: attr-id 0x1587 failed 3 retries
>>> [    6.967730] ufshcd-qcom 1da4000.ufshc: dme-peer-get: attr-id 0x1586 failed 3 retries
>>> [    6.975576] ufshcd-qcom 1da4000.ufshc: ufshcd_get_max_pwr_mode: invalid max pwm tx gear read = 0
>>> [    6.983306] ufshcd-qcom 1da4000.ufshc: ufshcd_probe_hba: Failed getting max supported power mode
>>> [    8.506314] ufshcd-qcom 1da4000.ufshc: ufshcd_query_flag: Sending flag query for idn 3 failed, err = -11
>>> [   10.010352] ufshcd-qcom 1da4000.ufshc: ufshcd_query_flag: Sending flag query for idn 3 failed, err = -11
>>> [   11.514313] ufshcd-qcom 1da4000.ufshc: ufshcd_query_flag: Sending flag query for idn 3 failed, err = -11
>>> [   11.514412] ufshcd-qcom 1da4000.ufshc: ufshcd_query_flag_retry: query attribute, opcode 5, idn 3, failed with error -11 after 3 retires
>>> [   13.050354] ufshcd-qcom 1da4000.ufshc: __ufshcd_query_descriptor: opcode 0x01 for idn 8 failed, index 0, err = -11
>>> [   14.554313] ufshcd-qcom 1da4000.ufshc: __ufshcd_query_descriptor: opcode 0x01 for idn 8 failed, index 0, err = -11
>>> [   16.058313] ufshcd-qcom 1da4000.ufshc: __ufshcd_query_descriptor: opcode 0x01 for idn 8 failed, index 0, err = -11
>>> [   16.058421] ufshcd-qcom 1da4000.ufshc: ufshcd_read_desc_param: Failed reading descriptor. desc_id 8, desc_index 0, param_offset 0, ret -11
>>> [   16.067654] ufshcd-qcom 1da4000.ufshc: ufshcd_init_icc_levels: Failed reading power descriptor.len = 98 ret = -11
>>> [   37.074334] ufshcd-qcom 1da4000.ufshc: link startup failed 1
>>
>> Can you check if your UFS device RESET_N is asserted correctly. It might
>> be connected to some regulator and may be you can try keeping that
>> regulator as "regulator-always-on" from your DT node.
> 
> How do I check RESET_N? In software or hardware?
> 
RST_N is the reset logic for UFS device core logic and it is input to 
the device from UFS host controller.So, in your platform please check if 
this line somehow connected to (pulled up) a PMIC supply. If that is the 
case, please keep that regulator ON and see if this issue is resolved.
> Do you think it is not a good idea to revert 60f0187031c05e04cbadffb62f557d0ff3564490 ?
> 
Please hold on till we understand the real cause of this issue. Or we 
have a consensuses for reverting the said commit.
Thanks!

> Regards.
> 
> 
