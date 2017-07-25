From: "Potomski, MichalX" <michalx.potomski@intel.com>
Subject: RE: [PATCH v2] scsi: ufs: Implement Auto-Hibern8 setup
Date: Tue, 25 Jul 2017 16:54:24 +0000
Message-ID: <C8BF859FC3044844854B2CBA1ED115C1F99AFB@HASMSX111.ger.corp.intel.com>
References: <20170725094514.19192-1-michalx.potomski@intel.com>
 <1500996626.3031.1.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:45830 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750732AbdGYQy3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Jul 2017 12:54:29 -0400
In-Reply-To: <1500996626.3031.1.camel@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "subhashj@codeaurora.org" <subhashj@codeaurora.org>, "Mielczarek, SzymonX" <szymonx.mielczarek@intel.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "vinholikatti@gmail.com" <vinholikatti@gmail.com>

> On Tue, 2017-07-25 at 11:45 +0200, Michal Potomski wrote:
> > Since Auto-Hibern8 feature has to be enabled by the user
> > proper API has been given via SysFS.
> >
> > We expose this API to user-space, since we don't know
> > in driver, what kind of additional Power Management rules
> > user wants to use. Due to that we want to expose API, to
> > let user or high level S/W decide, whether it wants to
> > use Auto-Hibern8 feature for Power Saving and give him
> > "slider" to decide between performance and power efficiency.
> > This is important because different platforms using
> > the same UFS host and/or device might want different
> > options on this one, e.g. High-End Desktop PC might
> > want to have this feature disabled, while Mobile or
> > Server platforms might want to have this feature enabled,
> > but levels will vary depending on what's to be acheived.
> >
> > As this feature is meant to be transparent for driver,
> > we'd like to let user decide whether he wants this enabled
> > or not.
> 
> Less than ten minutes after v1 of this patch was posted version v2 was
> posted. What is the difference between v1 and v2? Second and later versions
> of a patch or patch series are expected to include a changelog.
> 
V1 had some minor style issues, which were present in version that wasn't
targeted to be sent, hence the quick V2 post, which was the corrected one.

Proper changelog will be included in future versions.
> Since I'm not familiar with the Auto-Hibern8 feature: what impact does it
> have on command processing? Does it e.g. cause SCSI or TMF commands that
> are
> sent to the UFS device to be ignored, to fail or to time out?
> 
Actually behavior should be transparent for all of the higher layers, since this
shall be fully controlled by UFS Host, which will put UFS Device to Hibern8 state,
when it has no ongoing commands to it for set up time. If there will be any command
UFS Host should order the Device to exit Hibern8 mode and proceed normally.

Bottom line is that in model case, it shouldn't cause any of errors mentioned by you.
There is possible throughput degradation in case, if transfers are sporadic in terms
of timer, which we did set up, though. According to specification it also shouldn't affect
Hibern8 states triggered by Power Management, nor any other functionality.

I will alter commit message in V3, to cover this question.
> > +static ssize_t ufshcd_auto_hibern8_show(struct device *dev,
> > +		struct device_attribute *attr, char *buf)
> > +{
> > +	struct ufs_hba *hba = dev_get_drvdata(dev);
> > +	u32 val;
> > +	unsigned long timer;
> > +	u8 scale;
> > +	char *unit;
> > +
> > +	val = ufshcd_read_auto_hibern8_state(hba);
> > +	timer = val & UFSHCI_AHIBERN8_TIMER_MASK;
> > +	scale =	(val & UFSHCI_AHIBERN8_SCALE_MASK)
> > +			>> UFSHCI_AHIBERN8_SCALE_OFFSET;
> > +
> > +	unit = scale >= UFSHCI_AHIBERN8_SCALE_1MS ? "ms" : "us";
> > +
> > +	for (scale %= UFSHCI_AHIBERN8_SCALE_1MS; scale > 0; --scale)
> > +		timer *= UFS_AHIBERN8_SCALE_STEP_MAGNITUDE;
> > +
> > +	return snprintf(buf, PAGE_SIZE, "%ld %s\n", timer, unit);
> > +}
> 
> From Documentation/filesystems/sysfs.txt: "All new sysfs attributes must be
> documented in Documentation/ABI. See also Documentation/ABI/README for
> more
> information." Please add proper documentation of the attributes added by this
> patch when you resubmit this patch.
> 
> Regarding this attribute: units should be documented in Documentation/ABI/*/*
> instead of specifying these in the attribute itself. In other words, the
> "ms" / "us" suffix should be left out.
> 
Will be fixed in V3
> > @@ -7693,16 +7766,34 @@ static void
> ufshcd_add_spm_lvl_sysfs_nodes(struct ufs_hba *hba)
> >  		dev_err(hba->dev, "Failed to create sysfs for spm_lvl\n");
> >  }
> >
> > +static void ufshcd_add_ahibern8_sysfs_node(struct ufs_hba *hba)
> > +{
> > +	if (!(hba->capabilities & MASK_AUTO_HIBERN8_SUPPORT))
> > +		return;
> > +
> > +	hba->ahibern8_attr.show = ufshcd_auto_hibern8_show;
> > +	hba->ahibern8_attr.store = ufshcd_auto_hibern8_store;
> > +	sysfs_attr_init(&hba->ahibern8_attr.attr);
> > +	hba->ahibern8_attr.attr.name = "ufs_auto_hibern8";
> > +	hba->ahibern8_attr.attr.mode = 0600;
> > +	if (device_create_file(hba->dev, &hba->ahibern8_attr))
> > +		dev_err(hba->dev, "Failed to create sysfs for
> ufs_auto_hibern8\n");
> > +}
> 
> Please use a static variable at file scope and DRIVER_ATTR_RW() to initialize
> the sysfs attributes instead of initializing the sysfs attributes explicitly.
> 
> Additionally, please set sdev_attrs in struct scsi_host_template instead of
> calling device_create_file() explicitly. The above device_create_file() call
> occurs after a UFS device has been made visible in sysfs and hence will cause
> trouble (race condition) if a udev rule tries to set this attribute from inside
> a rule that is triggered by device creation.
> 
> I am aware the above code follows the style that is used for other UFS sysfs
> attributes. If you would have the time to convert the code for creating the
> existing UFS sysfs attributes that would be great.
> 
Will be added to V3 and sent as patch set.
> Thanks,
> 
> Bart.
Cheers,
Michal
--------------------------------------------------------------------

Intel Technology Poland sp. z o.o.
ul. Slowackiego 173 | 80-298 Gdansk | Sad Rejonowy Gdansk Polnoc | VII Wydzial Gospodarczy Krajowego Rejestru Sadowego - KRS 101882 | NIP 957-07-52-316 | Kapital zakladowy 200.000 PLN.

Ta wiadomosc wraz z zalacznikami jest przeznaczona dla okreslonego adresata i moze zawierac informacje poufne. W razie przypadkowego otrzymania tej wiadomosci, prosimy o powiadomienie nadawcy oraz trwale jej usuniecie; jakiekolwiek
przegladanie lub rozpowszechnianie jest zabronione.
This e-mail and any attachments may contain confidential material for the sole use of the intended recipient(s). If you are not the intended recipient, please contact the sender and delete all copies; any review or distribution by
others is strictly prohibited.
