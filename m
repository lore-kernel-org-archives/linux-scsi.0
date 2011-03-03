From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Subject: Re: [PATCH 7/15] megaraid_sas: Sanity check user supplied length in megasas_mgmt_fw_ioctl
Date: Thu, 03 Mar 2011 16:26:04 +0100
Message-ID: <874o7kgr8z.fsf@nemi.mork.no>
References: <AANLkTimgTBkOXV3gdvrQH0Vj7UnY6fXNECsFGc=7j2fO@mail.gmail.com>
	<4D6664BD.4080205@redhat.com>
	<AANLkTinCLCYeF_MF0KRSt6duuqWsYH3nsvWULFWN1JGp@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:42729 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753051Ab1CCPhW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Mar 2011 10:37:22 -0500
In-Reply-To: <AANLkTinCLCYeF_MF0KRSt6duuqWsYH3nsvWULFWN1JGp@mail.gmail.com>
	(adam radford's message of "Thu, 24 Feb 2011 16:54:50 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: Tomas Henzl <thenzl@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com, Ben Hutchings <ben@decadent.org.uk>

adam radford <aradford@gmail.com> writes:
> On Thu, Feb 24, 2011 at 6:01 AM, Tomas Henzl <thenzl@redhat.com> wrot=
e:
>>
>> there was proposed another patch for this issue -
>> http://marc.info/?l=3Dlinux-scsi&m=3D129542474703680&w=3D2
>> I think it's a little bit more precise.
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 0; i < ioc->sge_count; i++) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!ioc->sgl[i].=
iov_len)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 continue;
>> +
>>
>
> I didn't see this was already in scsi-misc-2.6.  I will re-base my
> patch series and repost.

Ben Hutchings noted as well in
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D604627#47
that this removes the initialisation of kern_sge32[i] when
ioc->sgl[i].iov_len is zero.

Inspecting smartmontools shows that it is not an issue with them, as
they always sge32[0].length =3D sgl[0].iov_len before issuing the
passthrough command:

/* Issue passthrough scsi command to PERC5/6 controllers */
bool linux_megaraid_device::megasas_cmd(int cdbLen, void *cdb,=20
  int dataLen, void *data,
  int /*senseLen*/, void * /*sense*/, int /*report*/)
{
  struct megasas_pthru_frame    *pthru;
  struct megasas_iocpacket      uio;
  int rc;

  memset(&uio, 0, sizeof(uio));
  pthru =3D (struct megasas_pthru_frame *)uio.frame.raw;
  pthru->cmd =3D MFI_CMD_PD_SCSI_IO;
  pthru->cmd_status =3D 0xFF;
  pthru->scsi_status =3D 0x0;
  pthru->target_id =3D m_disknum;
  pthru->lun =3D 0;
  pthru->cdb_len =3D cdbLen;
  pthru->timeout =3D 0;
  pthru->flags =3D MFI_FRAME_DIR_READ;
  pthru->sge_count =3D 1;
  pthru->data_xfer_len =3D dataLen;
  pthru->sgl.sge32[0].phys_addr =3D (intptr_t)data;
  pthru->sgl.sge32[0].length =3D (uint32_t)dataLen;
  memcpy(pthru->cdb, cdb, cdbLen);

  uio.host_no =3D m_hba;
  uio.sge_count =3D 1;
  uio.sgl_off =3D offsetof(struct megasas_pthru_frame, sgl);
  uio.sgl[0].iov_base =3D data;
  uio.sgl[0].iov_len =3D dataLen;

  rc =3D 0;
  errno =3D 0;
  rc =3D ioctl(m_fd, MEGASAS_IOC_FIRMWARE, &uio);





But to be utterly safe against userspace stupidity, the patch should
probably always set the kern_sge32[i].length.  Something like this,
maybe:=20



diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/m=
egaraid/megaraid_sas_base.c
index 5d6d07b..4cc65fd 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4611,6 +4611,11 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *i=
nstance,
         * For each user buffer, create a mirror buffer and copy in
         */
        for (i =3D 0; i < ioc->sge_count; i++) {
+               if (!ioc->sgl[i].iov_len) {
+                       kern_sge32[i].length =3D 0;
+                       continue;
+               }
+
                kbuff_arr[i] =3D dma_alloc_coherent(&instance->pdev->de=
v,
                                                    ioc->sgl[i].iov_len=
,
                                                    &buf_handle, GFP_KE=
RNEL);
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
