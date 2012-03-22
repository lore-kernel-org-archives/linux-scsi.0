From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [libsas PATCH v12 10/11] scsi, sd: limit the scope of the async
 probe domain
Date: Thu, 22 Mar 2012 12:09:57 -0700
Message-ID: <CABE8wws6=Vwi77GrRZXvVMAOnv6X=xxw3uRVgPbLZ0d5Zf7k3w@mail.gmail.com>
References: <20120322063245.22036.78652.stgit@dwillia2-linux.jf.intel.com>
	<Pine.LNX.4.44L0.1203221016580.1310-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1203221016580.1310-100000@iolanthe.rowland.org>
Sender: linux-ide-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Mar 22, 2012 at 7:20 AM, Alan Stern <stern@rowland.harvard.edu>=
 wrote:
> On Wed, 21 Mar 2012, Dan Williams wrote:
>
>> sd injects and synchronizes probe work on the global kernel-wide dom=
ain.
>> This runs into conflict with PM that wants to perform resume actions=
 in
>> async context:
>
> ...
>
>> Provide a 'scsi_sd_probe_domain' so that async probe actions actions=
 can
>> be flushed without regard for the state of PM, and allow for the res=
ume
>> path to handle devices that have transitioned from SDEV_QUIESCE to
>> SDEV_DEL prior to resume.
>
>> --- a/include/scsi/scsi_device.h
>> +++ b/include/scsi/scsi_device.h
>> @@ -393,6 +393,10 @@ static inline int scsi_autopm_get_device(struct=
 scsi_device *d) { return 0; }
>> =A0static inline void scsi_autopm_put_device(struct scsi_device *d) =
{}
>> =A0#endif /* CONFIG_PM_RUNTIME */
>>
>> +#if IS_ENABLED(CONFIG_PM) || IS_ENABLED(CONFIG_BLK_DEV_SD)
>> +extern struct list_head scsi_sd_probe_domain;
>> +#endif
>> +
>
> This doesn't need to be provided to drivers outside the SCSI core, so
> the declaration doesn't need to be in include/scsi. =A0I'd move it to
> drivers/scsi/scsi_priv.h.
>
> Apart from that,
>
> Acked-by: Alan Stern <stern@rowland.harvard.edu>

Thanks, will re-spin with the scsi_priv.h change.

--
Dan
