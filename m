From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v8 09/13] libsas: enforce eh strategy handlers only in eh context
Date: Wed, 29 Feb 2012 16:28:39 -0800
Message-ID: <CABE8wwuM1Hd9jTh+i63cZ=Fsf=c5Uwa6w0Rk+REsraxwEdZdYg@mail.gmail.com>
References: <20120210084411.25701.94502.stgit@dwillia2-linux.jf.intel.com>
	<20120210084525.25701.51128.stgit@dwillia2-linux.jf.intel.com>
	<1330553151.8846.26.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga07.intel.com ([143.182.124.22]:39513 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756920Ab2CAA2l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Feb 2012 19:28:41 -0500
Received: by obbwd18 with SMTP id wd18so41440obb.25
        for <linux-scsi@vger.kernel.org>; Wed, 29 Feb 2012 16:28:39 -0800 (PST)
In-Reply-To: <1330553151.8846.26.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

On Wed, Feb 29, 2012 at 2:05 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Fri, 2012-02-10 at 00:45 -0800, Dan Williams wrote:
>> The strategy handlers may be called in places that are problematic f=
or
>> libsas (i.e. sata resets outside of domain revalidation filtering /
>> libata link recovery), or problematic for userspace (non-blocking io=
ctl
>> to sleeping reset functions). =A0However, these routines are also ca=
lled
>> for eh escalations and recovery of scsi_eh_prep_cmnd(), so permit th=
em
>> as long as we are running in the host's error handler.
>>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>> =A0drivers/scsi/libsas/sas_scsi_host.c | =A0 15 +++++++++++----
>> =A01 files changed, 11 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libs=
as/sas_scsi_host.c
>> index f0b9b7b..1cabedc 100644
>> --- a/drivers/scsi/libsas/sas_scsi_host.c
>> +++ b/drivers/scsi/libsas/sas_scsi_host.c
>> @@ -463,11 +463,14 @@ EXPORT_SYMBOL_GPL(sas_get_local_phy);
>> =A0/* Attempt to send a LUN reset message to a device */
>> =A0int sas_eh_device_reset_handler(struct scsi_cmnd *cmd)
>> =A0{
>> - =A0 =A0 struct domain_device *dev =3D cmd_to_domain_dev(cmd);
>> - =A0 =A0 struct sas_internal *i =3D
>> - =A0 =A0 =A0 =A0 =A0 =A0 to_sas_internal(dev->port->ha->core.shost-=
>transportt);
>> - =A0 =A0 struct scsi_lun lun;
>> =A0 =A0 =A0 int res;
>> + =A0 =A0 struct scsi_lun lun;
>> + =A0 =A0 struct Scsi_Host *host =3D cmd->device->host;
>> + =A0 =A0 struct domain_device *dev =3D cmd_to_domain_dev(cmd);
>> + =A0 =A0 struct sas_internal *i =3D to_sas_internal(host->transport=
t);
>> +
>> + =A0 =A0 if (current !=3D host->ehandler)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return FAILED;
>
> Doing this will ensure that SG_SCSI_RESET now fails.
>
> I don't mind checking for O_NONBLOCK in the sg handler and failing if=
 it
> is, but disallowing everything looks a trifle drastic.
>

The thought process here was following the lead of libata which does
not specify eh_reset handlers.  We can't permit "unmanaged" (outside
of eh) resets to hit ata devices otherwise we run the risk of a reset
turning into a link bounce / hotplug.

=2E..and I can't take the same route as I did for the scsi_transport_sa=
s
initiated reset since these handlers are called from both ioctl and eh
context, or can I?

Hmm, what about something like:

  if (current !=3D host->ehandler) {
    schedule_reset_to_run_in_eh_context():
    wait_for_eh();
  } else
    do_reset();

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
