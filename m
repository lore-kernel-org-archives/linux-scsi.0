From: Cathy Avery <cavery@redhat.com>
Subject: Re: [PATCH 2/2] scsi: storvsc: Add support for FC lightweight host.
Date: Sun, 22 Jan 2017 13:51:13 -0500
Message-ID: <5884FF21.3050801@redhat.com>
References: <1484771338-8903-1-git-send-email-cavery@redhat.com>
 <1484771338-8903-3-git-send-email-cavery@redhat.com>
 <20170118231555.GC4454@mwanda> <5880FD8F.8020608@redhat.com>
 <20170120093116.GH4398@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20170120093116.GH4398@mwanda>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, haiyangz@microsoft.com, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, devel@linuxdriverproject.org
List-Id: linux-scsi@vger.kernel.org

I'm sorry.  In my zeal to push out this patch I have done a poor job of 
communication on a number of levels.

The first patch which deals with the fc transport changes will not set 
the scsi_transport_template.eh_timed_out function directly during 
lightweight fc_attach_transport(). It instead relies on whatever was 
indicated as the scsi_host_template timeout handler during 
inscsi_times_out() scsi_error.c.

So yes in a sense it is related but now I believe I understand your 
point. Perhaps this would fall more under the heading of post 
fc_transport implementation storvsc cleanup necessitating its own patch.

I will break it out in the next go round.

Thanks,

Cathy


On 01/20/2017 04:31 AM, Dan Carpenter wrote:
> On Thu, Jan 19, 2017 at 12:55:27PM -0500, Cathy Avery wrote:
>>
>> On 01/18/2017 06:15 PM, Dan Carpenter wrote:
>>> On Wed, Jan 18, 2017 at 03:28:58PM -0500, Cathy Avery wrote:
>>>> Enable FC lightweight host option so that the luns exposed by
>>>> the driver may be manually scanned.
>>>>
>>>> Signed-off-by: Cathy Avery <cavery@redhat.com>
>>>> ---
>>>>   drivers/scsi/storvsc_drv.c | 6 +-----
>>>>   1 file changed, 1 insertion(+), 5 deletions(-)
>>>>
>>>> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
>>>> index 888e16e..fc1d6ba 100644
>>>> --- a/drivers/scsi/storvsc_drv.c
>>>> +++ b/drivers/scsi/storvsc_drv.c
>>>> @@ -1882,6 +1882,7 @@ static struct hv_driver storvsc_drv = {
>>>>   static struct fc_function_template fc_transport_functions = {
>>>>   	.show_host_node_name = 1,
>>>>   	.show_host_port_name = 1,
>>>> +	.lightweight_transport = 1,
>>>>   };
>>>>   #endif
>>>> @@ -1906,11 +1907,6 @@ static int __init storvsc_drv_init(void)
>>>>   	fc_transport_template = fc_attach_transport(&fc_transport_functions);
>>>>   	if (!fc_transport_template)
>>>>   		return -ENODEV;
>>>> -
>>>> -	/*
>>>> -	 * Install Hyper-V specific timeout handler.
>>>> -	 */
>>>> -	fc_transport_template->eh_timed_out = storvsc_eh_timed_out;
>>> I don't undestand how removing this is related.
>> Its not related but it is also not necessary so I took it out. The
>> default scsi timeout handler will be used.
>>
>> I can certainly put it back.
> I'm not sure that we understand each other properly.
>
> Has this patch already been committed?  If so, then there is no need to
> put it back.
>
> But it if hasn't been committed, can you resend the patches with that
> bit broken out into a separate patch with its own changelog?  Patches
> should only do one thing but you're  saying that it's doing two
> unrelated things.
>
> regards,
> dan carpenter
>
