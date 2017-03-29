From: Jinpu Wang <jinpu.wang@profitbricks.com>
Subject: Re: [PATCH 1/2] scsi: sas: flush destruct workqueue on device unregister
Date: Wed, 29 Mar 2017 14:36:11 +0200
Message-ID: <CAMGffEnvL2f8rNxDSEp6NxmTs3V1Djq2Bavx8DsWGSwOcPJCXQ@mail.gmail.com>
References: <cover.1490775958.git.jthumshirn@suse.de> <9580eaf323f5da17dcace9e32b22a1df4099961d.1490775958.git.jthumshirn@suse.de>
 <02778435-6c67-0ac9-2faa-03ebb7934477@huawei.com> <20170329112922.GB9183@linux-x5ow.site>
 <343ddf8b-70e0-32f8-6ab8-31479729f827@huawei.com> <20170329122630.GD9183@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170329122630.GD9183@linux-x5ow.site>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: John Garry <john.garry@huawei.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Tejun Heo <tj@kernel.org>, James Bottomley <jejb@linux.vnet.ibm.com>, Dan Williams <dan.j.williams@intel.com>, Hannes Reinecke <hare@suse.de>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Mar 29, 2017 at 2:26 PM, Johannes Thumshirn <jthumshirn@suse.de> wr=
ote:
> On Wed, Mar 29, 2017 at 12:53:28PM +0100, John Garry wrote:
>> On 29/03/2017 12:29, Johannes Thumshirn wrote:
>> >On Wed, Mar 29, 2017 at 12:15:44PM +0100, John Garry wrote:
>> >>On 29/03/2017 10:41, Johannes Thumshirn wrote:
>> >>>In the advent of an SAS device unregister we have to wait for all des=
truct
>> >>>works to be done to not accidently delay deletion of a SAS rphy or it=
's
>> >>>children to the point when we're removing the SCSI or SAS hosts.
>> >>>
>> >>>Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
>> >>>---
>> >>>drivers/scsi/libsas/sas_discover.c | 4 ++++
>> >>>1 file changed, 4 insertions(+)
>> >>>
>> >>>diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas=
/sas_discover.c
>> >>>index 60de662..75b18f1 100644
>> >>>--- a/drivers/scsi/libsas/sas_discover.c
>> >>>+++ b/drivers/scsi/libsas/sas_discover.c
>> >>>@@ -382,9 +382,13 @@ void sas_unregister_dev(struct asd_sas_port *por=
t, struct domain_device *dev)
>> >>>   }
>> >>>
>> >>>   if (!test_and_set_bit(SAS_DEV_DESTROY, &dev->state)) {
>> >>>+          struct sas_discovery *disc =3D &dev->port->disc;
>> >>>+          struct sas_work *sw =3D &disc->disc_work[DISCE_DESTRUCT].w=
ork;
>> >>>+
>> >>>           sas_rphy_unlink(dev->rphy);
>> >>>           list_move_tail(&dev->disco_list_node, &port->destroy_list)=
;
>> >>>           sas_discover_event(dev->port, DISCE_DESTRUCT);
>> >>>+          flush_work(&sw->work);
>> >>
>> >>I quickly tested plugging out the expander and we never get past this =
call
>> >>to flush - a hang results:
>> >
>> >Can you activat lockdep so we can see which lock it is that we're block=
ing on?
>> >
>>
>> I have it on:
>> CONFIG_LOCKDEP_SUPPORT=3Dy
>> CONFIG_LOCKD=3Dy
>> CONFIG_LOCKD_V4=3Dy
>>
>> >It's most likely in sas_unregister_common_dev() but this function takes=
 two spin
>> >locks, port->dev_list_lock and ha->lock.
>> >
>>
>> We can see from the callstack I provided that we're working in workqueue
>> scsi_wq_0 and trying to flush that same queue.
>
> Aaahh, now I get what's happening (with some kicks^Whelp from Hannes I ad=
mit).
>
> The sas_unregister_dev() comes from the work queued by notify_phy_event()=
. So this patch must be
> replaced by (untested):
>
> diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transp=
ort_sas.c
> index cdbb293..e1e6492 100644
> --- a/drivers/scsi/scsi_transport_sas.c
> +++ b/drivers/scsi/scsi_transport_sas.c
> @@ -375,6 +375,7 @@ void sas_remove_children(struct device *dev)
>   */
>  void sas_remove_host(struct Scsi_Host *shost)
>  {
> +       scsi_flush_work(shost);
>         sas_remove_children(&shost->shost_gendev);
>  }
>  EXPORT_SYMBOL(sas_remove_host);
>
> John, mind giving that one a shot in your test setup as well?
>
> Thanks,
>         Johannes
>
> --
> Johannes Thumshirn                                          Storage
> jthumshirn@suse.de                                +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=C3=BCrnberg)
> Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850

Haha, I have same idea :)
Have no test env, so if John could test it, it will be great.
--=20
Jack Wang
Linux Kernel Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Tel:       +49 30 577 008  042
Fax:      +49 30 577 008 299
Email:    jinpu.wang@profitbricks.com
URL:      https://www.profitbricks.de

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Gesch=C3=A4ftsf=C3=BChrer: Achim Weiss
