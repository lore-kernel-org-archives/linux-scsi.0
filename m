From: "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Subject: Re: [<PATCH v1> 1/1] scsi: qcom-ufs: Add support for bus voting using
 ICB framework
Date: Fri, 25 Jan 2019 15:57:11 +0530
Message-ID: <4f58c58a-aeb6-6cad-96ac-43f6843715ce@codeaurora.org>
References: <cover.1548312692.git.asutoshd@codeaurora.org>
 <d6aa4d9bd29bbb2c3ee78e6635d4704e4113a26e.1548312692.git.asutoshd@codeaurora.org>
 <e91d4007-edab-da66-e241-bdf55bcf58aa@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <e91d4007-edab-da66-e241-bdf55bcf58aa@linaro.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Georgi Djakov <georgi.djakov@linaro.org>, subhashj@codeaurora.org, cang@codeaurora.org, vivek.gautam@codeaurora.org, rnayak@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>, "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" <devicetree@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 1/24/2019 5:16 PM, Georgi Djakov wrote:
> Hi Asutosh,
> 
> Thanks for the patch!
> 
> On 1/24/19 09:01, Asutosh Das wrote:
>> Adapt to the new ICB framework for bus bandwidth voting.
> 
> It's actually called interconnect API or interconnect framework.
Thanks! will change it.
> 
>> This requires the source/destination port ids.
>> Also this requires a tuple of values.
>>
>> The tuple is for two different paths - from UFS master
>> to BIMC slave. The other is from CPU master to UFS slave.
>> This tuple consists of the average and peak bandwidth.
>>
>> Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
>> ---
> 
> You can put here (below the --- line) the text from the cover letter.
> Usually people do not add separate cover letters for single patches.

Ok - will do so.
> 
>>   .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |  12 ++
>>   drivers/scsi/ufs/ufs-qcom.c                        | 234 ++++++++++++++++-----
>>   drivers/scsi/ufs/ufs-qcom.h                        |  20 ++
>>   3 files changed, 218 insertions(+), 48 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
>> index a99ed55..94249ef 100644
>> --- a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
>> +++ b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
>> @@ -45,6 +45,18 @@ Optional properties:
>>   Note: If above properties are not defined it can be assumed that the supply
>>   regulators or clocks are always on.
>>   
>> +* Following bus parameters are required:
>> +interconnects
>> +interconnect-names
> 
> Is the above really required? Are the interconnect bandwidth requests
> required to enable something critical to UFS functionality?
> Would UFS still work without any bandwidth scaling, although for example
> slower? Could you please clarify.
Yes - UFS will still work without any bandwidth scaling - but the 
performance would be terrible.

> 
>> +- Please refer to Documentation/devicetree/bindings/interconnect/
>> +  for more details on the above.
>> +qcom,msm-bus,name - string describing the bus path
>> +qcom,msm-bus,num-cases - number of configurations in which ufs can operate in
>> +qcom,msm-bus,num-paths - number of paths to vote for
>> +qcom,msm-bus,vectors-KBps - Takes a tuple <ib ab>, <ib ab> (2 tuples for 2 num-paths)
>> +			    The number of these entries *must* be same as
>> +			    num-cases.
> 
> DT bindings should be submitted as a separate patch. Anyway, people
> frown upon putting configuration data in DT. Could we put this data into
> the driver as a static table instead of DT? Also maybe use ab/pb for
> average/peak bandwidth.
The ab/ib value change depending on the target - that's the reasoning 
for putting it in dts file. However, I'm open to ideas as to how else to 
handle this.

Agree to changing it to pb.

> 
>> +
>>   Example:
>>   	ufshc@0xfc598000 {
>>   		compatible = "jedec,ufs-1.1";
>> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
>> index 2b38db2..213e975 100644
>> --- a/drivers/scsi/ufs/ufs-qcom.c
>> +++ b/drivers/scsi/ufs/ufs-qcom.c
>> @@ -16,6 +16,7 @@
>>   #include <linux/of.h>
>>   #include <linux/platform_device.h>
>>   #include <linux/phy/phy.h>
>> +#include <linux/interconnect.h>
>>   #include <linux/phy/phy-qcom-ufs.h>
> 
> Alphabetical order?
Agreed.

> 
>>   
>>   #include "ufshcd.h"
>> @@ -27,6 +28,10 @@
>>   #define UFS_QCOM_DEFAULT_DBG_PRINT_EN	\
>>   	(UFS_QCOM_DBG_PRINT_REGS_EN | UFS_QCOM_DBG_PRINT_TEST_BUS_EN)
>>   
>> +#define UFS_DDR "ufs-ddr"
>> +#define CPU_UFS "cpu-ufs"
> 
> Not sure if it's really useful to have them as #defines. Also maybe use
> "ufs-mem" instead of "ufs-ddr" to be more consistent with other users.
I can declare these as strings too - I don't have a preference.
Please let me know if you've a preference.
The reason for ufs-ddr was that it describes the path from ufs device to 
ddr. Am fine with ufs-mem too.

> 
>> +
>> +
>>   enum {
>>   	TSTBUS_UAWM,
>>   	TSTBUS_UARM,
>> @@ -714,7 +719,6 @@ static int ufs_qcom_get_pwr_dev_param(struct ufs_qcom_dev_params *qcom_param,
>>   	return 0;
>>   }
>>   
>> -#ifdef CONFIG_MSM_BUS_SCALING
>>   static int ufs_qcom_get_bus_vote(struct ufs_qcom_host *host,
>>   		const char *speed_mode)
>>   {
>> @@ -768,24 +772,83 @@ static void ufs_qcom_get_speed_mode(struct ufs_pa_layer_attr *p, char *result)
>>   	}
>>   }
>>   
>> +static int ufs_qcom_get_ib_ab(struct ufs_qcom_host *host, int index,
>> +			      struct qcom_bus_vectors *ufs_ddr_vec,
>> +			      struct qcom_bus_vectors *cpu_ufs_vec)
>> +{
>> +	struct qcom_bus_path *usecase;
>> +
>> +	if (!host->qbsd)
>> +		return -EINVAL;
>> +
>> +	if (index > host->qbsd->num_usecase)
>> +		return -EINVAL;
>> +
>> +	usecase = host->qbsd->usecase;
>> +
>> +	/*
>> +	 *
>> +	 * usecase:0  usecase:0
>> +	 * ufs->ddr   cpu->ufs
>> +	 * |vec[0&1] | vec[2&3]|
>> +	 * +----+----+----+----+
>> +	 * | ab | ib | ab | ib |
>> +	 * |----+----+----+----+
>> +	 * .
>> +	 * .
>> +	 * .
>> +	 * usecase:n  usecase:n
>> +	 * ufs->ddr   cpu->ufs
>> +	 * |vec[0&1] | vec[2&3]|
>> +	 * +----+----+----+----+
>> +	 * | ab | ib | ab | ib |
>> +	 * |----+----+----+----+
>> +	 */
>> +
>> +	/* index refers to offset in usecase */
>> +	ufs_ddr_vec->ab = usecase[index].vec[0].ab;
>> +	ufs_ddr_vec->ib = usecase[index].vec[0].ib;
>> +
>> +	cpu_ufs_vec->ab = usecase[index].vec[1].ab;
>> +	cpu_ufs_vec->ib = usecase[index].vec[1].ib;
>> +
>> +	return 0;
>> +}
>> +
>>   static int ufs_qcom_set_bus_vote(struct ufs_qcom_host *host, int vote)
>>   {
>>   	int err = 0;
>> +	struct qcom_bus_scale_data *d = host->qbsd;
>> +	struct qcom_bus_vectors path0, path1;
>> +	struct device *dev = host->hba->dev;
>>   
>> -	if (vote != host->bus_vote.curr_vote) {
>> -		err = msm_bus_scale_client_update_request(
>> -				host->bus_vote.client_handle, vote);
>> -		if (err) {
>> -			dev_err(host->hba->dev,
>> -				"%s: msm_bus_scale_client_update_request() failed: bus_client_handle=0x%x, vote=%d, err=%d\n",
>> -				__func__, host->bus_vote.client_handle,
>> -				vote, err);
>> -			goto out;
>> -		}
>> +	err = ufs_qcom_get_ib_ab(host, vote, &path0, &path1);
>> +	if (err) {
>> +		dev_err(dev, "Error: failed (%d) to get ib/ab\n",
>> +			err);
>> +		return err;
>> +	}
>>   
>> -		host->bus_vote.curr_vote = vote;
>> +	dev_dbg(dev, "Setting vote: %d: ufs-ddr: ab: %llu ib: %llu\n", vote,
>> +		path0.ab, path0.ib);
>> +	err = icc_set_bw(d->ufs_ddr, path0.ab, path0.ib);
>> +	if (err) {
>> +		dev_err(dev, "Error: (%d) failed setting (%s) bus vote\n", err,
>> +			UFS_DDR);
>> +		return err;
>>   	}
>> -out:
>> +
>> +	dev_dbg(dev, "Setting: cpu-ufs: ab: %llu ib: %llu\n", path1.ab,
>> +		path1.ib);
>> +	err = icc_set(d->cpu_ufs, path1.ab, path1.ib);
>> +	if (err) {
>> +		dev_err(dev, "Error: (%d) failed setting (%s) bus vote\n", err,
>> +			CPU_UFS);
>> +		return err;
>> +	}
>> +
>> +	host->bus_vote.curr_vote = vote;
>> +
>>   	return err;
>>   }
>>   
>> @@ -807,6 +870,7 @@ static int ufs_qcom_update_bus_bw_vote(struct ufs_qcom_host *host)
>>   		dev_err(host->hba->dev, "%s: failed %d\n", __func__, err);
>>   	else
>>   		host->bus_vote.saved_vote = vote;
>> +
>>   	return err;
>>   }
>>   
>> @@ -837,34 +901,114 @@ static int ufs_qcom_update_bus_bw_vote(struct ufs_qcom_host *host)
>>   	return count;
>>   }
>>   
>> +static struct qcom_bus_scale_data *ufs_qcom_get_bus_scale_data(struct device
>> +							       *dev)
>> +
>> +{
>> +	struct platform_device *pdev = to_platform_device(dev);
>> +	struct device_node *of_node = dev->of_node;
>> +	struct qcom_bus_scale_data *qsd;
>> +	struct qcom_bus_path *usecase = NULL;
>> +	int ret = 0, i = 0, j, num_paths, len;
>> +	const uint32_t *vec_arr = NULL;
> 
> Please use u32 instead of uint32_t.
Agreed.

> 
>> +	bool mem_err = false;
>> +
>> +	if (!pdev) {
>> +		dev_err(dev, "Null platform device!\n");
>> +		return NULL;
>> +	}
>> +
>> +	qsd = devm_kzalloc(dev, sizeof(struct qcom_bus_scale_data), GFP_KERNEL);
>> +	if (!qsd)
>> +		return NULL;
>> +
>> +	ret = of_property_read_string(of_node, "qcom,msm-bus,name", &qsd->name);
>> +	if (ret) {
>> +		dev_err(dev, "Error: (%d) Bus name missing!\n", ret);
>> +		return NULL;
>> +	}
>> +
>> +	ret = of_property_read_u32(of_node, "qcom,msm-bus,num-cases",
>> +		&qsd->num_usecase);
>> +	if (ret) {
>> +		pr_err("Error: num-usecases not found\n");
>> +		goto err;
>> +	}
>> +
>> +	usecase = devm_kzalloc(dev, (sizeof(struct qcom_bus_path) *
>> +				   qsd->num_usecase), GFP_KERNEL);
>> +	if (!usecase)
>> +		return NULL;
>> +
>> +	ret = of_property_read_u32(of_node, "qcom,msm-bus,num-paths",
>> +				   &num_paths);
>> +	if (ret) {
>> +		pr_err("Error: num_paths not found\n");
>> +		return NULL;
>> +	}
>> +
>> +	vec_arr = of_get_property(of_node, "qcom,msm-bus,vectors-KBps", &len);
>> +	if (vec_arr == NULL) {
>> +		pr_err("Error: Vector array not found\n");
>> +		return NULL;
>> +	}
>> +
>> +	for (i = 0; i < qsd->num_usecase; i++) {
>> +		usecase[i].num_paths = num_paths;
>> +		usecase[i].vec = devm_kzalloc(dev, num_paths *
>> +					      sizeof(struct qcom_bus_vectors),
>> +					      GFP_KERNEL);
>> +		if (!usecase[i].vec) {
>> +			mem_err = true;
>> +			dev_err(dev, "Error: Failed to alloc mem for vectors\n");
>> +			goto err;
>> +		}
>> +
>> +		for (j = 0; j < num_paths; j++) {
>> +			int idx = ((i * num_paths) + j) * 2;
>> +
>> +			usecase[i].vec[j].ab = (uint64_t)
>> +				be32_to_cpu(vec_arr[idx]);
>> +			usecase[i].vec[j].ib = (uint64_t)
>> +				be32_to_cpu(vec_arr[idx + 1]);
>> +		}
>> +	}
>> +
>> +	qsd->usecase = usecase;
>> +	return qsd;
>> +err:
>> +	if (mem_err) {
>> +		for (; i > 0; i--)
>> +			kfree(usecase[i].vec);
>> +	}
>> +	return NULL;
>> +}
> 
> We wouldn't need all the above DT parsing if we add a sdm845 bandwidth
> usecase table. Could you give it a try?
Replied above - Please let me know if you've any suggestions on how else 
to handle this, as it can change with targets.

> 
> Thanks,
> Georgi
> 

Hi Georgi - thanks for the comments.
Replied to your comments inline.

-asd

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a 
Linux Foundation Collaborative Project
