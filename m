From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v8 05/11] libata-eh: allow defer in ata_exec_internal
Date: Tue, 30 Oct 2012 11:09:21 +0800
Message-ID: <508F44E1.3000801@intel.com>
References: <1351501298-3716-1-git-send-email-aaron.lu@intel.com> <1351501298-3716-6-git-send-email-aaron.lu@intel.com> <20121029152051.GK5171@htj.dyndns.org> <508F42C0.8070807@intel.com> <20121030030144.GG4066@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <20121030030144.GG4066@htj.dyndns.org>
Sender: linux-pm-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@hansenpartnership.com>, Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>, Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, Shane Huang <shane.huang@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/30/2012 11:01 AM, Tejun Heo wrote:
> Hello,
> 
> On Tue, Oct 30, 2012 at 11:00:16AM +0800, Aaron Lu wrote:
>>> Why not do the discovery from EH?
>>
>> Do you mean set a device level EH flag and then schedule EH to do the
>> discovery?
> 
> Yeah, something like that or why can't it be done while probing the
> device in the first place?

I'm not aware of a place to store such ODD specific information when
probing the device.

I'm currently storing the loading mech type in structure zpodd, which
gets created after the corresponding SCSI device gets created in
ata_scsi_scan_host, so at the probe time, the zpodd structure does not
exist yet. And the reason I create the zpodd sturcture this late is
that, it is only created when the ODD together the platform is ZPODD
capable, and to find out if this platform is ZPODD capbale, ACPI binding
has to occur first, and ACPI binding happens when SCSI device is added
to the device tree.

Thanks,
Aaron

