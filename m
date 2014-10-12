From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] target: iscsi: iscsi_target_tpg.c:  Cleaning up
 possible size overwriting in conjunction with sprintf
Date: Sun, 12 Oct 2014 11:18:43 -0700
Message-ID: <1413137923.22149.27.camel@joe-AO725>
References: <1413136558-20790-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1413136558-20790-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Sender: linux-kernel-owner@vger.kernel.org
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Sagi Grimberg <sagig@mellanox.com>, Andy Grover <agrover@redhat.com>, Thomas Glanzmann <thomas@glanzmann.de>, Christophe Vu-Brugier <cvubrugier@yahoo.fr>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, 2014-10-12 at 19:55 +0200, Rickard Strandqvist wrote:
> Changed same snprintf and sprintf to strlcpy and strlcat.
> This will guarantee that the string size is not overwritten,
> and they are significantly faster than sprintf also.

I don't disagree with the change, but I think the changelog is
misleading.

strlcpy(ptr, ...) then strlcat(ptr, ...) does not use the known
length of the first copied string and is generally not faster than
ptr += snprintf(ptr, ...) then sprintf(ptr,...)

And a couple slightly unrelated bits:

> diff --git a/drivers/target/iscsi/iscsi_target_tpg.c b/drivers/target/iscsi/iscsi_target_tpg.c
> index c3cb5c1..6fc8bfe 100644
> --- a/drivers/target/iscsi/iscsi_target_tpg.c
> +++ b/drivers/target/iscsi/iscsi_target_tpg.c
> @@ -608,7 +608,6 @@ int iscsit_tpg_set_initiator_node_queue_depth(
>  int iscsit_ta_authentication(struct iscsi_portal_group *tpg, u32 authentication)

This function could be made static and the prototype removed from
the .h file if it is moved above its one caller in this file.

>  {
>  	unsigned char buf1[256], buf2[256], *none = NULL;

Moderately large stack use here.
