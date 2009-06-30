From: zhou sf <sxzzsf@gmail.com>
Subject: Re: SG_DXFER_TO_FROM_DEV does not copy user buffer to driver buffer
	in linux 2.6.28 and later?
Date: Tue, 30 Jun 2009 15:56:32 +0800
Message-ID: <42a6d9690906300056y41f3c97bo431ddcb458272035@mail.gmail.com>
References: <42a6d9690906281750i65c5c3ccy6bfac5e1055bae77@mail.gmail.com>
	 <4A48A860.5010803@interlog.com>
	 <20090630154455Q.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yx0-f188.google.com ([209.85.210.188]:35897 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbZF3H43 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jun 2009 03:56:29 -0400
Received: by yxe26 with SMTP id 26so2084817yxe.33
        for <linux-scsi@vger.kernel.org>; Tue, 30 Jun 2009 00:56:32 -0700 (PDT)
In-Reply-To: <20090630154455Q.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: dgilbert@interlog.com, linux-scsi@vger.kernel.org

It works under 2.6.28.

2009/6/30 FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>:
> On Mon, 29 Jun 2009 13:41:20 +0200
> Douglas Gilbert <dgilbert@interlog.com> wrote:
>
>> The semantics of SG_DXFER_TO_FROM_DEV were:
>> =A0 =A0- copy user space buffer to kernel (LLD) buffer
>> =A0 =A0- do SCSI command which is assumed to be of the DATA_IN
>> =A0 =A0 =A0(data from device) variety. This would overwrite
>> =A0 =A0 =A0some or all of the kernel buffer
>> =A0 =A0- copy kernel (LLD) buffer back to the user space.
>>
>> The idea was to detect short reads by filling the original
>> user space buffer with some marker bytes ("0xec" it would
>> seem in this report). The "resid" value is a better way
>> of detecting short reads but that was only added this century
>> and requires co-operation from the LLD.
>>
>> There were major plumbing changes in the sg driver around
>> lk 2.6.28 and it looks like the above nuance was lost.
>> Perhaps the block layer does support the above "double
>> shuffle".
>
> Sorry, I overlooked SG_DXFER_TO_FROM_DEV.
>
> Does this patch work?
>
>
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 8201387..8df3b6a 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -1658,6 +1658,10 @@ static int sg_start_req(Sg_request *srp, unsig=
ned char *cmd)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0md->nr_entries =3D req_schp->k_use_sg;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0md->offset =3D 0;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0md->null_mapped =3D hp->dxferp ? 0 : 1=
;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (dxfer_dir =3D=3D SG_DXFER_TO_FROM_D=
EV)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 md->from_user =3D 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 md->from_user =3D 0;
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0if (iov_count) {
> diff --git a/fs/bio.c b/fs/bio.c
> index 24c9140..e467dd8 100644
> --- a/fs/bio.c
> +++ b/fs/bio.c
> @@ -705,14 +705,13 @@ static struct bio_map_data *bio_alloc_map_data(=
int nr_segs, int iov_count,
> =A0}
>
> =A0static int __bio_copy_iov(struct bio *bio, struct bio_vec *iovecs,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct sg_iovec *io=
v, int iov_count, int uncopy,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int do_free_page)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct sg_iovec *io=
v, int iov_count,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int to_user, int fr=
om_user, int do_free_page)
> =A0{
> =A0 =A0 =A0 =A0int ret =3D 0, i;
> =A0 =A0 =A0 =A0struct bio_vec *bvec;
> =A0 =A0 =A0 =A0int iov_idx =3D 0;
> =A0 =A0 =A0 =A0unsigned int iov_off =3D 0;
> - =A0 =A0 =A0 int read =3D bio_data_dir(bio) =3D=3D READ;
>
> =A0 =A0 =A0 =A0__bio_for_each_segment(bvec, bio, i, 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0char *bv_addr =3D page_address(bvec->b=
v_page);
> @@ -727,13 +726,14 @@ static int __bio_copy_iov(struct bio *bio, stru=
ct bio_vec *iovecs,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0iov_addr =3D iov[iov_i=
dx].iov_base + iov_off;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!ret) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!re=
ad && !uncopy)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 ret =3D copy_from_user(bv_addr, iov_addr,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bytes);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rea=
d && uncopy)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (to_=
user)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0ret =3D copy_to_user(iov_addr, bv_addr,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bytes);
>
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (fro=
m_user)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 ret =3D copy_from_user(bv_addr, iov_addr,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bytes);
> +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (re=
t)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0ret =3D -EFAULT;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> @@ -770,7 +770,8 @@ int bio_uncopy_user(struct bio *bio)
>
> =A0 =A0 =A0 =A0if (!bio_flagged(bio, BIO_NULL_MAPPED))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D __bio_copy_iov(bio, bmd->iovec=
s, bmd->sgvecs,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0bmd->nr_sgvecs, 1, bmd->is_our_pages);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0bmd->nr_sgvecs, bio_data_dir(bio) =3D=3D READ,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A00, bmd->is_our_pages);
> =A0 =A0 =A0 =A0bio_free_map_data(bmd);
> =A0 =A0 =A0 =A0bio_put(bio);
> =A0 =A0 =A0 =A0return ret;
> @@ -875,8 +876,9 @@ struct bio *bio_copy_user_iov(struct request_queu=
e *q,
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * success
> =A0 =A0 =A0 =A0 */
> - =A0 =A0 =A0 if (!write_to_vm && (!map_data || !map_data->null_mappe=
d)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D __bio_copy_iov(bio, bio->bi_io_=
vec, iov, iov_count, 0, 0);
> + =A0 =A0 =A0 if ((!write_to_vm && (!map_data || !map_data->null_mapp=
ed)) ||
> + =A0 =A0 =A0 =A0 =A0 (map_data && map_data->from_user)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D __bio_copy_iov(bio, bio->bi_io_=
vec, iov, iov_count, 0, 1, 0);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ret)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto cleanup;
> =A0 =A0 =A0 =A0}
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 8963d91..36c5ff8 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -730,6 +730,7 @@ struct rq_map_data {
> =A0 =A0 =A0 =A0int nr_entries;
> =A0 =A0 =A0 =A0unsigned long offset;
> =A0 =A0 =A0 =A0int null_mapped;
> + =A0 =A0 =A0 int from_user;
> =A0};
>
> =A0struct req_iterator {
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
