From: Marc Gonzalez <marc.w.gonzalez@free.fr>
Subject: Re: [PATCH v5 1/2] scsi: ufs: Do not disable vccq in UFSHC driver
Date: Tue, 26 Feb 2019 18:02:18 +0100
Message-ID: <8fc2eed2-f94b-8d43-6ca4-86e18f600997@free.fr>
References: <494cd639-89a7-8868-b63a-ea7cdcba9777@free.fr>
 <be3ef9bf-438b-4e8a-62c4-f75458e8ecc0@free.fr> <yq1ftsad2yi.fsf@oracle.com>
 <b7f37c2d-27c7-9b58-20c8-52624783a6fa@free.fr> <yq1bm2yd2kr.fsf@oracle.com>
 <026c10b1-48e8-ab9f-fda8-6e3557b841a7@free.fr> <yq1y362bjnw.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1y362bjnw.fsf@oracle.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: SCSI <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Jeffrey Hugo <jhugo@codeaurora.org>, Bjorn Andersson <bjorn.andersson@linaro.org>, Evan Green <evgreen@chromium.org>, Douglas Anderson <dianders@chromium.org>, Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, Joao Pinto <jpinto@synopsys.com>, Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>, Rob Herring <robh+dt@kernel.org>, Bart Van Assche <bart.vanassche@wdc.com>, Stanislav Nijnikov <stanislav.nijnikov@wdc.com>, Alex Lemberg <alex.lemberg@wdc.com>, Ohad Sharabi <ohad.sharabi@wdc.com>, Hannes Reinecke <hare@suse.de>, Kyuho Choi <kyuho.choi@sk.com>
List-Id: linux-scsi@vger.kernel.org

On 26/02/2019 17:26, Martin K. Petersen wrote:

>> I indeed started off from 'git revert'
>>
>> $ git revert 60f0187031c0
>> warning: inexact rename detection was skipped due to too many files.
>> warning: you may want to set your merge.renamelimit variable to at
>> least 18258 and retry the command.
>> error: could not revert 60f0187031c0... scsi: ufs: disable vccq if
>> it's not needed by UFS device
>> hint: after resolving the conflicts, mark the corrected paths
>> hint: with 'git add <paths>' or 'git rm <paths>'
>> hint: and commit the result with 'git commit'
>>
>> So I had to resolve the conflict in ufshcd_probe_hba()
>>
>> The line:
>>
>> 	ufs_advertise_fixup_device(hba);
>>
>> was modified by commit 93fdd5ac64bbe80dac6416f048405362d7ef0945
> 
> If it's a resolvable delta, a proper git revert is preferred. Please
> document any conflicts in the commit message and list the relevant
> commits that introduced them.
> 
> If you find yourself in a situation where reverting simply isn't
> feasible, I'd expect the commit to state "This should have been a revert
> but I'd have to boil the oceans to resolve the conflicts because XYZ..."

OK, I'll do my best, but I've never been in this situation before.

According to git blame, ufshcd_probe_hba() has been heavily modified
around the ufshcd_set_vccq_rail_unused() call to be reverted:

a4b0e8a4e92b1 (Potomski, MichalX     2017-02-23 09:05:30 +0000 6820)    /* Init check for device descriptor sizes */
a4b0e8a4e92b1 (Potomski, MichalX     2017-02-23 09:05:30 +0000 6821)    ufshcd_init_desc_sizes(hba);
a4b0e8a4e92b1 (Potomski, MichalX     2017-02-23 09:05:30 +0000 6822) 
93fdd5ac64bbe (Tomas Winkler         2017-01-05 10:45:12 +0200 6823)    ret = ufs_get_device_desc(hba, &card);
93fdd5ac64bbe (Tomas Winkler         2017-01-05 10:45:12 +0200 6824)    if (ret) {
93fdd5ac64bbe (Tomas Winkler         2017-01-05 10:45:12 +0200 6825)            dev_err(hba->dev, "%s: Failed getting device info. err = %d\n",
93fdd5ac64bbe (Tomas Winkler         2017-01-05 10:45:12 +0200 6826)                    __func__, ret);
93fdd5ac64bbe (Tomas Winkler         2017-01-05 10:45:12 +0200 6827)            goto out;
93fdd5ac64bbe (Tomas Winkler         2017-01-05 10:45:12 +0200 6828)    }
93fdd5ac64bbe (Tomas Winkler         2017-01-05 10:45:12 +0200 6829) 
93fdd5ac64bbe (Tomas Winkler         2017-01-05 10:45:12 +0200 6830)    ufs_fixup_device_setup(hba, &card);
371131065de99 (Yaniv Gardi           2016-03-10 17:37:16 +0200 6831)    ufshcd_tune_unipro_params(hba);
60f0187031c05 (Yaniv Gardi           2016-03-10 17:37:11 +0200 6832) 
60f0187031c05 (Yaniv Gardi           2016-03-10 17:37:11 +0200 6833)    ret = ufshcd_set_vccq_rail_unused(hba,
60f0187031c05 (Yaniv Gardi           2016-03-10 17:37:11 +0200 6834)            (hba->dev_quirks & UFS_DEVICE_NO_VCCQ) ? true : false);
60f0187031c05 (Yaniv Gardi           2016-03-10 17:37:11 +0200 6835)    if (ret)
60f0187031c05 (Yaniv Gardi           2016-03-10 17:37:11 +0200 6836)            goto out;
60f0187031c05 (Yaniv Gardi           2016-03-10 17:37:11 +0200 6837) 
57d104c153d3d (Subhash Jadavani      2014-09-25 15:32:30 +0300 6838)    /* UFS device is also active now */
57d104c153d3d (Subhash Jadavani      2014-09-25 15:32:30 +0300 6839)    ufshcd_set_ufs_dev_active(hba);
66ec6d59407ba (Sujit Reddy Thumma    2013-07-30 00:35:59 +0530 6840)    ufshcd_force_reset_auto_bkops(hba);
57d104c153d3d (Subhash Jadavani      2014-09-25 15:32:30 +0300 6841)    hba->wlun_dev_clr_ua = true;


So the patch to revert is 60f0187031c05.

57d104c153d3d and 66ec6d59407ba are older, so no problem there.

Basically, we just need to preserve the lines from
371131065de99, 93fdd5ac64bbe, a4b0e8a4e92b1
and we're good to go.

The conflict looks like this:

<<<<<<< HEAD
	/* Init check for device descriptor sizes */
	ufshcd_init_desc_sizes(hba);

	ret = ufs_get_device_desc(hba, &card);
	if (ret) {
		dev_err(hba->dev, "%s: Failed getting device info. err = %d\n",
			__func__, ret);
		goto out;
	}

	ufs_fixup_device_setup(hba, &card);
	ufshcd_tune_unipro_params(hba);

	ret = ufshcd_set_vccq_rail_unused(hba,
		(hba->dev_quirks & UFS_DEVICE_NO_VCCQ) ? true : false);
	if (ret)
		goto out;

=======
	ufs_advertise_fixup_device(hba);
>>>>>>> parent of 60f0187031c0... scsi: ufs: disable vccq if it's not needed by UFS device


The resolution is simple: we keep the HEAD version, and simply remove
ufshcd_set_vccq_rail_unused() and its error-handling.


Is that the information you were after?


Do you prefer the patch subject to be:
Revert "scsi: ufs: disable vccq if it's not needed by UFS device"
instead of:
scsi: ufs: Do not disable vccq in UFSHC driver

And I should leave in the automatically added
This reverts commit 60f0187031c05e04cbadffb62f557d0ff3564490.
while adding some information from the manual resolution?

Regards.
