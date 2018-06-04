From: Evan Green <evgreen@chromium.org>
Subject: Re: [PATCH 3/7] scsi: ufs: Make sysfs attributes writable
Date: Mon, 4 Jun 2018 08:39:35 -0700
Message-ID: <CAE=gft6Jj0S9iqqAaAo5NsHBMxkVDVTb7mjMAS0RvQs8qhh3gQ@mail.gmail.com>
References: <20180529181740.195362-1-evgreen@chromium.org> <20180529181740.195362-4-evgreen@chromium.org>
 <bde08554b8939de962a88068bb132ab320f8f7a5.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <bde08554b8939de962a88068bb132ab320f8f7a5.camel@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart.VanAssche@wdc.com
Cc: jejb@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, Vinayak Holikatti <vinholikatti@gmail.com>, Stanislav.Nijnikov@wdc.com, Gwendal Grignou <gwendal@chromium.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jun 4, 2018 at 1:33 AM Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
>
> On Tue, 2018-05-29 at 11:17 -0700, Evan Green wrote:
> > +static ssize_t _name##_store(struct device *dev,                     \
> > +             struct device_attribute *attr, const char *buf,         \
> > +             size_t count)                                           \
> > +{                                                                    \
> > +     struct ufs_hba *hba = dev_get_drvdata(dev);                     \
> > +     unsigned long value;                                            \
> > +     if (kstrtoul(buf, 0, &value))                                   \
> > +             return -EINVAL;                                         \
> > +     if (ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,        \
> > +             QUERY_ATTR_IDN##_uname, 0, 0, (u32 *)&value))           \
> > +             return -EINVAL;                                         \
> > +     return count;                                                   \
> > +}                                                                    \
>
> Casting an "unsigned long" pointer into an u32 pointer looks evil to me.
> Please don't do this.
>

Will fix.
