From: "Adam J. Richter" <adam@yggdrasil.com>
Subject: Re: [PATCH] get rid of ->detect for upper layer drivers
Date: Thu, 7 Nov 2002 08:16:09 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200211071616.IAA29896@adam.yggdrasil.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: andmike@us.ibm.com
Cc: hch@lst.de, linux-scsi@vger.kernel.org

[Resending due to an email problem on my end.  Sorry if this is a
duplicate. -Adam]

Michael Anderson wrote:
>The removal of detect should eventually result in other reductions /
>cleaner code (If the sg binding issue can be resolved cleanly).

        What makes you think that?  You need a way to ask "is this
driver interested in this device" and that's all that the code
remaining in scsi_device_template.detect() does after you remove the
side effects (i.e., the counter incrementing), and it does so about as
simply as possible.

        I haven't looked at it closely, but there seems to be
workaround in the generic device code for its inability to bind more
than one driver to a device: struct device_interface, which seems to
duplicate much of the generic driver interface but lacks
device->driver_data, which we could compensate for by adding
a field in struct scsi_device:

struct scsi_device {
       ...
        struct sg_device *sg_dev;       /* For use by SCSI generic only. */
};

        Since device_interface API closely resembles that of
device_driver, it would probably be easy to port sg to device_driver
that API is every changed to support multiple drivers per device.

Adam J. Richter     __     ______________   575 Oroville Road
adam@yggdrasil.com     \ /                  Milpitas, California 95035
+1 408 309-6081         | g g d r a s i l   United States of America
                         "Free Software For The Rest Of Us."
