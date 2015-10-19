From: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 13/25] scsi: hisi_sas: add path from phyup irq to SAS
 framework
Date: Mon, 19 Oct 2015 15:55:47 +0100
Message-ID: <56250473.9090700@huawei.com>
References: <1444663237-238302-1-git-send-email-john.garry@huawei.com>
 <6858991.h0xpYFqkjM@wuerfel> <5624FA23.1050502@huawei.com>
 <4269975.xfCo9ut8KK@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4269975.xfCo9ut8KK@wuerfel>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangfei.gao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, john.garry2-s/0ZXS5h9803lw97EnAbAg@public.gmane.org, hare-l3A5Bk7waGM@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

>>> I'd have to review more closely, but I think that's fine, as this
>>> is how most work queues are used: you can queue the same function
>>> multiple times, and it's guaranteed to run at least once after
>>> the last queue, so if you queue it while it's already running,
>>> it will be called again, otherwise it won't.
>>>
>> In the scenario I described the issue is not that the second call to
>> queue the work function is lost. The problem is that when we setup the
>> second call we may overwrite elements of the phy's hisi_sas_wq struct
>> which may be still being referenced in the work function for the first call.
>
> Do you mean these members?
>
>> +       wq->event = PHYUP;
>> +       wq->hisi_hba = hisi_hba;
>> +       wq->phy_no = phy_no;
>
Yes, these are the members I was referring to. However there is also an 
element "data" in hisi_sas_wq. This is used in control phy as follows:
int hisi_sas_control_phy(struct asd_sas_phy *sas_phy,
			enum phy_func func,
			void *funcdata)
{
	...
	wq->event = CONTROL_PHY;
	wq->data = func;
	...
	INIT_WORK(&wq->work_struct, hisi_sas_wq_process);
	queue_work(hisi_hba->wq, &wq->work_struct);
}

void hisi_sas_wq_process(struct work_struct *work)
{
	struct hisi_sas_wq *wq =
		container_of(work, struct hisi_sas_wq, work_struct);
	switch (wq->event) {
	case CONTROL_PHY:
		hisi_sas_control_phy_work(hisi_hba, wq->data, phy_no);
}

static void hisi_sas_control_phy_work(struct hisi_hba *hisi_hba,
				int func,
				int phy_no)
{
	switch (func) {
	case PHY_FUNC_HARD_RESET:
		hard_phy_reset_v1_hw(hisi_hba, phy_no)

> Sorry for being unclear, I implied getting rid of them, by having a
> work queue per phy. You can create a structure for each phy like
>
> 	struct hisi_sas_phy {
> 		struct hisi_sas *dev; /* pointer to the device */
> 		unsigned int phy_no;
> 		struct work_struct phyup_work;
> 	};
>
> There are probably other things you can put into the same structure.
> When the phy is brought up, you then just start the phyup work for
> that phy, which can retrieve its hisi_sas_phy structure from the
> work_struct pointer, and from there get to the device.
>
> 	Arnd
>
> .
>
We could create a work_struct for each event, which would be fine. 
However we would sometimes still need some way of passing data to the 
event, like the phy control example.

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
