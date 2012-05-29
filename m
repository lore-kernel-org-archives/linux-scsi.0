From: Sergei Shtylyov <sshtylyov@mvista.com>
Subject: Re: [PATCH v4 01/13] [SCSI]: add wrapper to access and set scsi_bus_type
 in struct acpi_bus_type
Date: Tue, 29 May 2012 16:26:17 +0400
Message-ID: <4FC4C069.1000906@mvista.com>
References: <1338181720-4149-1-git-send-email-ming.m.lin@intel.com> <1338181720-4149-2-git-send-email-ming.m.lin@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1338181720-4149-2-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, David Woodhouse <David.Woodhouse@intel.com>, Aaron Lu <aaron.lu@amd.com>, Holger Macht <holger@homac.de>, Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello.

On 28-05-2012 9:08, Lin Ming wrote:

> From: Holger Macht<holger@homac.de>

> For being able to bind ata devices against acpi devices, scsi_bus_type
> needs to be set as bus in struct acpi_bus_type. So add wrapper to
> scsi_lib to accomplish that.

> Signed-off-by: Holger Macht<holger@homac.de>
> Signed-off-by: Lin Ming<ming.m.lin@intel.com>
> ---
>   drivers/scsi/scsi_lib.c |   17 +++++++++++++++++
>   include/scsi/scsi.h     |   10 ++++++++++
>   2 files changed, 27 insertions(+), 0 deletions(-)

> diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
> index f34a5a8..4527b3a 100644
> --- a/include/scsi/scsi.h
> +++ b/include/scsi/scsi.h
> @@ -214,6 +214,16 @@ scsi_command_size(const unsigned char *cmnd)
>   		scsi_varlen_cdb_length(cmnd) : COMMAND_SIZE(cmnd[0]);
>   }
>
> +#ifdef CONFIG_ACPI

    You don't have to enclode declarations into #ifdef.

> +struct acpi_bus_type;
> +
> +extern int

    'extern' is the default memory class for function, no need to specidy it.
And don't break the line here.

> +scsi_register_acpi_bus_type(struct acpi_bus_type *bus);
> +
> +extern void

    Same comment.

> +scsi_unregister_acpi_bus_type(struct acpi_bus_type *bus);
> +#endif

MBR, Sergei
