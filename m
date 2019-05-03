From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/3] ibmvscsi: Wire up host_reset() in the drivers
 scsi_host_template
Date: Thu, 2 May 2019 17:37:26 -0700
Message-ID: <d21f91d4-20f7-5519-147d-0e4eb37004ae@linux.vnet.ibm.com>
References: <20190502004729.19962-1-tyreld@linux.ibm.com>
 <29e15e27-8cc6-d45e-a9e1-80603278dda2@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <29e15e27-8cc6-d45e-a9e1-80603278dda2@linux.vnet.ibm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: Brian King <brking@linux.vnet.ibm.com>, Tyrel Datwyler <tyreld@linux.ibm.com>, james.bottomley@hansenpartnership.com
Cc: brking@linux.ibm.com, linuxppc-dev@lists.ozlabs.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com
List-Id: linux-scsi@vger.kernel.org

On 05/02/2019 02:50 PM, Brian King wrote:
> On 5/1/19 7:47 PM, Tyrel Datwyler wrote:
>> From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
>>
>> Wire up the host_reset function in our driver_template to allow a user
>> requested adpater reset via the host_reset sysfs attribute.
>>
>> Example:
>>
>> echo "adapter" > /sys/class/scsi_host/host0/host_reset
>>
>> Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
>> ---
>>  drivers/scsi/ibmvscsi/ibmvscsi.c | 13 +++++++++++++
>>  1 file changed, 13 insertions(+)
>>
>> diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
>> index 8cec5230fe31..1c37244f16a0 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvscsi.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
>> @@ -2050,6 +2050,18 @@ static struct device_attribute ibmvscsi_host_config = {
>>  	.show = show_host_config,
>>  };
>>  
>> +static int ibmvscsi_host_reset(struct Scsi_Host *shost, int reset_type)
>> +{
>> +	struct ibmvscsi_host_data *hostdata = shost_priv(shost);
>> +
>> +	vio_disable_interrupts(to_vio_dev(hostdata->dev));
>> +	dev_info(hostdata->dev, "Initiating adapter reset!\n");
>> +	ibmvscsi_reset_host(hostdata);
>> +	vio_enable_interrupts(to_vio_dev(hostdata->dev));
> 
> Is it necessary to disable / enable interrupts around the call to ibmvscsi_reset_host?
> I don't know why we'd need to do that before calling the reset as we have other
> cases, like ibmvscsi_timeout where we don't bother doing this. Also, at the end
> of the reset we look to be already enabling interrupts.

Yeah, I think you are right. My initial line of thought was that we have
interrupts disabled in handle_crq when we do a reset, but yeah we clearly call
it in the case of a timeout with them enabled.

-Tyrel

> 
> Thanks,
> 
> Brian
> 
