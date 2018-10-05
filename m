From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH] scsi: iscsi_tcp: Explicitly cast param in iscsi_sw_tcp_host_get_param
Date: Fri, 5 Oct 2018 14:20:47 -0700
Message-ID: <CAKwvOdk1M0t2WeB5AQjwzDy5Pb6HKV=kmh5kWrxNszFzaLjo7Q@mail.gmail.com>
References: <20181004010615.19782-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181004010615.19782-1-natechancellor@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nathan Chancellor <natechancellor@gmail.com>
Cc: lduncan@suse.com, cleech@redhat.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Oct 3, 2018 at 6:06 PM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> Clang warns when one enumerated type is implicitly converted to another.
>
> drivers/scsi/iscsi_tcp.c:803:15: warning: implicit conversion from
> enumeration type 'enum iscsi_host_param' to different enumeration type
> 'enum iscsi_param' [-Wenum-conversion]
>                                                  &addr, param, buf);
>                                                         ^~~~~
> 1 warning generated.
>
> iscsi_conn_get_addr_param handles ISCSI_HOST_PARAM_IPADDRESS just fine
> so add an explicit cast to iscsi_param to make it clear to Clang that
> this is expected behavior.
>
> Link: https://github.com/ClangBuiltLinux/linux/issues/153
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>  drivers/scsi/iscsi_tcp.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
> index b025a0b74341..23354f206533 100644
> --- a/drivers/scsi/iscsi_tcp.c
> +++ b/drivers/scsi/iscsi_tcp.c
> @@ -800,7 +800,8 @@ static int iscsi_sw_tcp_host_get_param(struct Scsi_Host *shost,
>                         return rc;
>
>                 return iscsi_conn_get_addr_param((struct sockaddr_storage *)
> -                                                &addr, param, buf);
> +                                                &addr,
> +                                                (enum iscsi_param)param, buf);

Alternatively, you could also just pass ISCSI_HOST_PARAM_IPADDRESS in
place of the cast (since in this case param ==
ISCSI_HOST_PARAM_IPADDRESS), but I don't feel strongly about this
(maybe the maintainers do).
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

>         default:
>                 return iscsi_host_get_param(shost, param, buf);
>         }
> --
> 2.19.0
>


-- 
Thanks,
~Nick Desaulniers
