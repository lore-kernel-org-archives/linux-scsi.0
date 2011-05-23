From: Roland Dreier <roland@kernel.org>
Subject: Re: [PATCH][SCSI] target: Fix double test of inquiry_prod
Date: Mon, 23 May 2011 10:20:29 -0700
Message-ID: <BANLkTinKNKk3uW=+rDYd_9Bdqi7CXWWkag@mail.gmail.com>
References: <1303920422-31142-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog104.obsmtp.com ([74.125.245.76]:50418 "HELO
	na3sys010aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756353Ab1EWRUu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 May 2011 13:20:50 -0400
Received: by mail-qw0-f46.google.com with SMTP id 3so3887319qwk.5
        for <linux-scsi@vger.kernel.org>; Mon, 23 May 2011 10:20:49 -0700 (PDT)
In-Reply-To: <1303920422-31142-1-git-send-email-roland@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org

On Wed, Apr 27, 2011 at 9:07 AM, Roland Dreier <roland@kernel.org> wrot=
e:
> From: Roland Dreier <roland@purestorage.com>
>
> The code really intends to make sure that neither inquiry_prod nor
> inquiry_rev is NULL.
>
> Signed-off-by: Roland Dreier <roland@purestorage.com>
> ---
> =A0drivers/target/target_core_transport.c | =A0 =A02 +-
> =A01 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/=
target_core_transport.c
> index 9583b23..4a03098 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -1725,7 +1725,7 @@ struct se_device *transport_add_device_to_core_=
hba(
> =A0 =A0 =A0 =A0 * setup.
> =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0if (TRANSPORT(dev)->transport_type !=3D TRANSPORT_PLUG=
IN_PHBA_PDEV) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!(inquiry_prod) || !(inquiry_prod))=
 {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!inquiry_prod || !inquiry_rev) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printk(KERN_ERR "All n=
on TCM/pSCSI plugins require"
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0" INQU=
IRY consts\n");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
>

Hi Nick, did you ever get a chance to look at this?  Seems pretty obvio=
us to me.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
