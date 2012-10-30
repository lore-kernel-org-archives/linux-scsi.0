From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v8 05/11] libata-eh: allow defer in ata_exec_internal
Date: Tue, 30 Oct 2012 11:00:16 +0800
Message-ID: <508F42C0.8070807@intel.com>
References: <1351501298-3716-1-git-send-email-aaron.lu@intel.com> <1351501298-3716-6-git-send-email-aaron.lu@intel.com> <20121029152051.GK5171@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20121029152051.GK5171@htj.dyndns.org>
Sender: linux-acpi-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@hansenpartnership.com>, Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>, Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, Shane Huang <shane.huang@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/29/2012 11:20 PM, Tejun Heo wrote:
> On Mon, Oct 29, 2012 at 05:01:32PM +0800, Aaron Lu wrote:
>> ata_exec_internal will preempt the ata link's active_tag and ata port's
>> qc_active flags, this is OK for error recovery, but if normal code path
>> wants to use ata_exec_internal, there is a problem: we need to check if
>> it is OK to issue a new command with the help of port_ops->defer.
>>
>> In ZPODD, I'll need to find out the loading mechanism of the ODD by
>> issuing a GET_CONFIGURATION command. And this command may very well
>> race with commands issued from SCSI layer. So instead of preempt the
>> current command, defer the new command if it's not OK to issue it, as
>> it is always wrong to issue a non-NCQ command when there is command(s)
>> in processing.
> 
> Why not do the discovery from EH?

Do you mean set a device level EH flag and then schedule EH to do the
discovery?

Thanks,
Aaron

