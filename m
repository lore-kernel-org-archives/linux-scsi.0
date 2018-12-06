From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH v4 2/5] scsi: hisi_sas: Relocate some code to reduce
 complexity
Date: Thu, 6 Dec 2018 15:37:46 +0000
Message-ID: <2da87e22-1bbc-aff9-c0be-85a3fd8f4393@huawei.com>
References: <1544103284-100497-1-git-send-email-john.garry@huawei.com>
 <1544103284-100497-3-git-send-email-john.garry@huawei.com>
 <c7ec9e23-6da8-35e0-1996-02db3d640f4b@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c7ec9e23-6da8-35e0-1996-02db3d640f4b@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org

On 06/12/2018 14:17, Johannes Thumshirn wrote:
> On 06/12/2018 14:34, John Garry wrote:
> [...]
>> +static void hisi_sas_dma_unmap(struct hisi_hba *hisi_hba,
>> +			       struct sas_task *task, int n_elem,
>> +			       int n_elem_req, int n_elem_resp)
>> +{
>> +	struct device *dev = hisi_hba->dev;
>> +
>> +	if (!sas_protocol_ata(task->task_proto)) {
>> +		if (task->num_scatter) {
>> +			if (n_elem)
>> +				dma_unmap_sg(dev, task->scatter,
>> +					     task->num_scatter,
>> +					     task->data_dir);
>> +		} else if (task->task_proto & SAS_PROTOCOL_SMP) {
>> +			if (n_elem_req)
>> +				dma_unmap_sg(dev, &task->smp_task.smp_req,
>> +					     1, DMA_TO_DEVICE);
>> +			if (n_elem_resp)
>> +				dma_unmap_sg(dev, &task->smp_task.smp_resp,
>> +					     1, DMA_FROM_DEVICE);
>> +		}
>> +	}
>
> 	if (sas_protocol_ata(task->task_proto))
> 		return;
>
> Would save you a level of indentation and make the above more readable.
>
>

Hi Johannes,

Whilst I agree with the idea, the current approach makes the function 
more symmetic with its mapping buddy, hisi_sas_dma_map():

static void hisi_sas_dma_unmap(struct hisi_hba *hisi_hba,
                    struct sas_task *task, int n_elem,
                    int n_elem_req, int n_elem_resp)
{
     struct device *dev = hisi_hba->dev;

     if (!sas_protocol_ata(task->task_proto)) {
         if (task->num_scatter) {
             if (n_elem)
                 dma_unmap_sg(dev, task->scatter,

	...
}

static int hisi_sas_dma_map(struct hisi_hba *hisi_hba,
                 struct sas_task *task, int *n_elem,
                 int *n_elem_req, int *n_elem_resp)
{
     struct device *dev = hisi_hba->dev;
     int rc;

     if (sas_protocol_ata(task->task_proto)) {
         *n_elem = task->num_scatter;
     } else {
         unsigned int req_len, resp_len;

         if (task->num_scatter) {
             *n_elem = dma_map_sg(dev, task->scatter,
                          task->num_scatter, task->data_dir);
    		...

}

which is important. Let me know if you disagree and I can change it.

Thanks,
John
